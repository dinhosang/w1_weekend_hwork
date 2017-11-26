def pet_shop_name(shop_details)
  shop_name = shop_details[:name]
  return shop_name
end


def total_cash(shop_details)
  sum_cash = shop_details[:admin][:total_cash]
  return sum_cash
end


def add_or_remove_cash(shop_details, amount)
  shop_details[:admin][:total_cash] += amount
end


def pets_sold(shop_details)
  total_sold = shop_details[:admin][:pets_sold]
  return total_sold
end


def increase_pets_sold(shop_details, number_just_sold)
  shop_details[:admin][:pets_sold] += number_just_sold
end


def stock_count(shop_details)
  total_pets_in_shop = shop_details[:pets].size()
  return total_pets_in_shop
end


def pets_by_breed(shop_details, sought_breed)
  shop_pets = shop_details[:pets]
  number_of_breed = []
  for pet in shop_pets
    if pet[:breed] == sought_breed
      number_of_breed.push(pet[:name])
    end
  end
  return number_of_breed
end


def find_pet_by_name(shop_details, sought_pet_name)
  shop_pets = shop_details[:pets]
  for pet in shop_pets
    pet_name = pet[:name]
    if pet_name == sought_pet_name
      return pet
    end
  end
  return nil
end


def remove_pet_by_name(shop_details, sought_pet_name)
  shop_pets = shop_details[:pets]
  for pet in shop_pets
    pet_name = pet[:name]
    if pet_name == sought_pet_name
      shop_details[:pets].delete(pet)
    end
  end
end


def add_pet_to_stock(shop_details, new_pet)
    shop_details[:pets].push(new_pet)
end


def customer_pet_count(customer_to_check)
  cust_pet_amount_array = customer_to_check[:pets]
  return cust_pet_amount_array.size()
end


def add_pet_to_customer(customer, new_pet)
  customer_pets = customer[:pets]
  customer_pets.push(new_pet)
end


def customer_can_afford_pet(customer, new_pet)
  available_cash = customer[:cash]
  pet_cost = new_pet[:price]
  if pet_cost < available_cash
    return true
  end
  return false
end


def remove_cash_from_customer(customer, cost_of_pet)
  customer[:cash] -= cost_of_pet
end

def sell_pet_to_customer(shop_details, pet, customer)
  if pet != nil
    if customer_can_afford_pet(customer, pet) != false
      add_pet_to_customer(customer, pet)
      increase_pets_sold(shop_details, 1)
      price_of_pet = pet[:price]
      add_or_remove_cash(shop_details, price_of_pet)
      remove_cash_from_customer(customer, price_of_pet)
    end
  end
end
