def pet_shop_name(shop_details)
  shop_name = shop_details[:name]
  return shop_name
end

def total_cash(shop_details)
  sum_cash = shop_details[:admin][:total_cash]
  return sum_cash
end
