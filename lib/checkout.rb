require 'checkout_item'

class Checkout
  attr_reader :rules, :items

  def initialize(rules=[])
    @rules = rules
    @items = []
  end

  # Adds one item to the checkout
  def scan(item)
    items << CheckoutItem.new(item)
  end

  # Returns the total before rules are applied
  def subtotal
    items.map(&:price).reduce(&:+)
  end

  # Returns the total with rules applied, as an integer
  def total
    apply_rules(subtotal).round
  end

  # Returns the total with rules applied, as a decimal value
  def decimal_total
    sprintf("%03d", total).insert(-3, ".")
  end

  private

  def apply_rules(subtotal)
    rules.reduce(subtotal){|memo, rule|
      rule.apply_to(memo, items)
    }
  end
end
