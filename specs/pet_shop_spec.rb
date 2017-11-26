require 'minitest/autorun'
require_relative '../pet_shop'

class TestPetShop < Minitest::Test

  def setup

    @customers = [
      {
        name: "Craig",
        pets: [],
        cash: 1000
      },
      {
        name: "Zsolt",
        pets: [],
        cash: 50
      }
    ]

    @new_pet = {
            name: "Bors the Younger",
            pet_type: :cat,
            breed: "Cornish Rex",
            price: 100
          }

    @pet_shop = {
        pets: [
          {
            name: "Sir Percy",
            pet_type: :cat,
            breed: "British Shorthair",
            price: 500
          },
          {
            name: "King Bagdemagus",
            pet_type: :cat,
            breed: "British Shorthair",
            price: 500
          },
          {
            name: "Sir Lancelot",
            pet_type: :dog,
            breed: "Pomsky",
            price: 1000,
          },
          {
            name: "Arthur",
            pet_type: :dog,
            breed: "Husky",
            price: 900,
          },
          {
            name: "Tristan",
            pet_type: :dog,
            breed: "Basset Hound",
            price: 800,
          },
          {
            name: "Merlin",
            pet_type: :cat,
            breed: "Egyptian Mau",
            price: 1500,
          }
        ],
        admin: {
          total_cash: 1000,
          pets_sold: 0,
        },
        name: "Camelot of Pets"
      }
  end

  def test_pet_shop_name
    name = pet_shop_name(@pet_shop)
    assert_equal("Camelot of Pets", name)
  end

  def test_total_cash
    sum = total_cash(@pet_shop)
    assert_equal(1000, sum)
  end

  def test_add_or_remove_cash__add
    add_or_remove_cash(@pet_shop,10)
    cash = total_cash(@pet_shop)
    assert_equal(1010, cash)
  end

  def test_add_or_remove_cash__remove
    add_or_remove_cash(@pet_shop,-10)
    cash = total_cash(@pet_shop)
    assert_equal(990, cash)
  end

  def test_pets_sold
    sold = pets_sold(@pet_shop)
    assert_equal(0, sold)
  end

  def test_increase_pets_sold
    increase_pets_sold(@pet_shop,2)
    sold = pets_sold(@pet_shop)
    assert_equal(2, sold)
  end

  def test_stock_count
    count = stock_count(@pet_shop)
    assert_equal(6, count)
  end

  def test_all_pets_by_breed__found
    pets = pets_by_breed(@pet_shop, "British Shorthair")
    assert_equal(2, pets.count)
  end

  def test_all_pets_by_breed__not_found
    pets = pets_by_breed(@pet_shop, "Dalmation")
    assert_equal(0, pets.count)
  end

  def test_find_pet_by_name__returns_pet
    pet = find_pet_by_name(@pet_shop, "Arthur")
    assert_equal("Arthur", pet[:name])
  end

  def test_find_pet_by_name__returns_nil
    pet = find_pet_by_name(@pet_shop, "Fred")
    assert_nil(pet)
  end

  def test_remove_pet_by_name
    remove_pet_by_name(@pet_shop, "Arthur")
    pet = find_pet_by_name(@pet_shop,"Arthur")
    assert_nil(pet)
  end

  def test_add_pet_to_stock
    add_pet_to_stock(@pet_shop, @new_pet)
    count = stock_count(@pet_shop)
    assert_equal(7, count)
  end

  def test_customer_pet_count
    count = customer_pet_count(@customers[0])
    assert_equal(0, count)
  end

  def test_add_pet_to_customer
    customer = @customers[0]
    add_pet_to_customer(customer, @new_pet)
    assert_equal(1, customer_pet_count(customer))
  end

  # # OPTIONAL

  def test_customer_can_afford_pet__insufficient_funds
    customer = @customers[1]
    can_buy_pet = customer_can_afford_pet(customer, @new_pet)
    assert_equal(false, can_buy_pet)
  end

  def test_customer_can_afford_pet__sufficient_funds
    customer = @customers[0]
    can_buy_pet = customer_can_afford_pet(customer, @new_pet)
    assert_equal(true, can_buy_pet)
  end

  #These are 'integration' tests so we want multiple asserts.
  #If one fails the entire test should fail
  def test_sell_pet_to_customer__pet_found
    customer = @customers[0]
    pet = find_pet_by_name(@pet_shop,"Arthur")
    sell_pet_to_customer(@pet_shop, pet, customer)

    assert_equal(1, customer_pet_count(customer))
    assert_equal(1, pets_sold(@pet_shop))
    assert_equal(1900, total_cash(@pet_shop))
    # additional test for changing customer wallet
    pet_cost = pet[:price]
    expected_cust_wallet = 100
    actual_cust_wallet = customer[:cash]
    assert_equal(expected_cust_wallet, actual_cust_wallet)
  end

  def test_sell_pet_to_customer__pet_not_found
    customer = @customers[0]
    pet = find_pet_by_name(@pet_shop,"Dave")

    sell_pet_to_customer(@pet_shop, pet, customer)

    assert_equal(0, customer_pet_count(customer))
    assert_equal(0, pets_sold(@pet_shop))
    assert_equal(1000, total_cash(@pet_shop))
    # additional test for changing customer wallet
    expected_cust_wallet = 1000
    actual_cust_wallet = customer[:cash]
    assert_equal(expected_cust_wallet, actual_cust_wallet)
  end

  def test_sell_pet_to_customer__insufficient_funds
    customer = @customers[1]
    pet = find_pet_by_name(@pet_shop,"Arthur")

    sell_pet_to_customer(@pet_shop, pet, customer)

    assert_equal(0, customer_pet_count(customer))
    assert_equal(0, pets_sold(@pet_shop))
    assert_equal(1000, total_cash(@pet_shop))
    # additional test for changing customer wallet
    expected_cust_wallet = 50
    actual_cust_wallet = customer[:cash]
    assert_equal(expected_cust_wallet, actual_cust_wallet)
  end

# extra testing - for removing customer money, removing
# pet, and purchasing pet from customer

  # below commented out due to changing function name to reflect widened purpose
  # new function test is detailed directly below this commented out funcion
  # def test_remove_cash_from_customer
  #   customer = @customers[0]
  #   cost_of_pet = 200
  #   expectd = 800
  #   remove_cash_from_customer(customer, cost_of_pet)
  #   customer_wallet = customer[:cash]
  #   assert_equal(800, customer_wallet)
  #   # to reset for other tests - turns out it's not needed?
  #   # due to def setup made at start of class
  #   #customer[:cash] += 200
  # end


  def test_change_customer_wallet_amount
    customer = @customers[0]
    cost_of_pet = 200
    expectd = 800
    affect_to_customer_wallet = cost_of_pet * (-1)
    change_customer_wallet_amount(customer, affect_to_customer_wallet)
    customer_wallet = customer[:cash]
    assert_equal(800, customer_wallet)
  end


  def test_purchase_animal_from_customer
    customer = @customers[1]
    pet = @new_pet
    shop = @pet_shop
    add_pet_to_customer(customer, pet)

    purchase_animal_from_customer(customer, pet, shop)

    customer_wallet = customer[:cash]
    shop_balance = total_cash(@pet_shop)
    checking_pet_in_shop = find_pet_by_name(@pet_shop, "Bors the Younger")
    checking_pet_with_customer = find_pet_by_name(customer, "Bors the Younger")

    assert_nil(checking_pet_with_customer)
    assert_equal(150, customer_wallet)
    assert_equal(pet, checking_pet_in_shop)
    assert_equal(900, shop_balance)
  end


  def test_purchase_animal_from_customer__pet_not_found
    customer = @customers[1]
    pet = @new_pet
    shop = @pet_shop

    purchase_animal_from_customer(customer, pet, shop)

    customer_wallet = customer[:cash]
    shop_balance = total_cash(@pet_shop)
    checking_pet_in_shop = find_pet_by_name(@pet_shop, "Bors the Younger")
    checking_pet_with_customer = find_pet_by_name(customer, "Bors the Younger")

    assert_nil(checking_pet_in_shop)
    assert_nil(checking_pet_with_customer)
    assert_equal(50, customer_wallet)
    assert_equal(1000, shop_balance)
  end


  def test_purchase_animal_from_customer__insufficient_funds
    customer = @customers[1]
    pet = @new_pet
    shop = @pet_shop
    add_pet_to_customer(customer, pet)
    shop[:admin][:total_cash] = 95

    purchase_animal_from_customer(customer, pet, shop)

    customer_wallet = customer[:cash]
    shop_balance = total_cash(@pet_shop)
    checking_pet_in_shop = find_pet_by_name(@pet_shop, "Bors the Younger")
    checking_pet_with_customer = find_pet_by_name(customer, "Bors the Younger")

    assert_nil(checking_pet_in_shop)
    assert_equal(pet, checking_pet_with_customer)
    assert_equal(50, customer_wallet)
    assert_equal(95, shop_balance)
  end
end
