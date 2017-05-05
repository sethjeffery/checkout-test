# Represents one item added to the checkout.
class CheckoutItem
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def price
    item.price
  end

  def product_code
    item.product_code
  end
end
