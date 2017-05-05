# Represents an item in the catalogue.
class Item
  attr_accessor :price, :product_code, :name

  def initialize(args={})
    self.price = args[:price]
    self.product_code = args[:product_code]
    self.name = args[:name]
  end

  def decimal_price
    sprintf("%03d", price).insert(-3, ".")
  end
end
