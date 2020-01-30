def consolidate_cart(cart)
  cart.reduce({}) { |hash, item|
    itemKey = item.keys.first
    if hash.key?(itemKey)
      hash[itemKey][:count] += 1
    else
      hash[itemKey] = item[itemKey].clone
      hash[itemKey][:count] = 1
    end
    hash
  }
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    item = coupon[:item]
    couponItem = "#{item} W/COUPON"
    if (cart.key?(item) &&
        cart[item][:count] >= coupon[:num])
      cart[item][:count] -= coupon[:num]
      if (cart.key?(couponItem))
        cart[couponItem][:count] += coupon[:num]
      else
        cart[couponItem] = cart[item].clone
        cart[couponItem][:price] = coupon[:cost] / coupon[:num]
        cart[couponItem][:count] = coupon[:num]
      end
    end
  }
  cart
end

def apply_clearance(cart)
  cart.each { |item, data|
    if (data[:clearance])
      data[:price] = (data[:price] * 0.8).round(2)
    end
  }
end

def checkout(cart, coupons)
  total = apply_clearance(apply_coupons(consolidate_cart(cart), coupons)).values.reduce(0) {
    |cost, item|
    cost + item[:price] * item[:count]
  }
  total > 100 ? total * 0.9 : total
end
