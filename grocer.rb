require 'pry'

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  i = 0
  result = nil

  while i < collection.length do
    if collection[i][:item] == name
      result = collection[i]
    end
  i += 1
  end
  result
end
#This methods return value will be either nil or the item hash

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  i = 0
  new_cart = []

  while i < cart.length do
    new_cart_item = find_item_by_name_in_collection(cart[i][:item], new_cart)
    if new_cart_item != nil
       #If new_cart_item is present then...
       new_cart_item[:count] += 1
       #Increase :count :key by one.
    else
      #Recreates hash that, but also adds a new :counter key and sets it to 1
      new_cart_item = {
        item: cart[i][:item],
        price: cart[i][:price],
        clearance: cart[i][:clearance],
        count: 1
      }
      new_cart << new_cart_item
    end
    i += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  i = 0

  while i < coupons.length do

    cart_item = find_item_by_name_in_collection( coupons[i][:item], cart)
      #By setting second argument to cart, we searching through cart for the
      #first argument, which is the coupon item name to see if ther are any
      #matches. Will return nil or entire item hash.

    couponed_item_name = "#{coupons[i][:item]} W/COUPON"
      #Checks to see if coupon already exists in the cart.

    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
      #Variable will check if item with coupon already exists in our cast, so
      #later on if it already exists, we will only be increasing its count, not
      #adding a redudant coupon. Return value Will either be nil or coupon item hash

    if cart_item && cart_item[:count] >= coupons[i][:num]
    #If the coupon item exists in the cart array and matching cart item :count
    #is greater than or eqaul to number [:num] of coupon item we are
    #currently iterating through. Runs code below.
      if cart_item_with_coupon != nil #If couponed item already exists in cart array
        cart_item_with_coupon[:count] += coupons[i][:num]
          #We take the [:count] # of existing coupon and increase it by [:num] from our matching coupon item.
        cart_item[:count] -= coupons[i][:num]
          #Subtract coupon :num value from cart item existing :count value
          #What about if it reaches cart_item[:count] becomes less than 1? Write nested if here to remove it?
      else
        cart_item_with_coupon = {
          item: couponed_item_name,
          price: coupons[i][:cost]/coupons[i][:num],
          count: coupons[i][:num],
          clearance: cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[i][:num]
      end
    end
    i += 1
  end
  cart
end

def apply_clearance(cart)
i = 0

 while i < cart.length do
   if cart[i][:clearance] == true
      cart[i][:price] = ((cart[i][:price]) * 0.8).round(2)
   end
   i += 1
 end
 cart
end

def checkout(cart, coupons)
consolidated_cart = consolidate_cart(cart)
cart_with_coupons_applied = apply_coupons(consolidated_cart, coupons)
cart_with_coupons_and_clearance_applied = apply_clearance(cart_with_coupons_applied)
grand_total = 0
i = 0

  while i < cart_with_coupons_and_clearance_applied.length do
    grand_total += cart_with_coupons_and_clearance_applied[i][:count] * cart_with_coupons_and_clearance_applied[i][:price]
    i += 1
  end

  if grand_total > 100
    grand_total = (grand_total * 0.9).round(2)
  end
grand_total
end
# Consult README for inputs and outputs
#
# This method should call
# * consolidate_cart
# * apply_coupons
# * apply_clearance
#
# BEFORE it begins the work of calculating the total (or else you might have
# some irritated customers
