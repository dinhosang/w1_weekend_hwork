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
