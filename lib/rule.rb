require 'yaml'

class Rule
  attr_accessor :product_code, :percent_discount, :per_item_discount
  attr_accessor :spend_threshold, :qty_threshold

  # product_code:      Fixes a rule to a specific product. If nil, applies to entire cart.
  # percent_discount:  Discounts the price by a percentage amount (as a fraction).
  # per_item_discount: Discounts the price by a certain amount per item (in pence/cents).
  # spend_threshold:   Applies the rule if the user spends at least the given amount.
  # qty_threshold:     Applies the rule if the user buys enough items.
  #
  def initialize(args={})
    self.product_code = args[:product_code]
    self.percent_discount = args[:percent_discount]
    self.per_item_discount = args[:per_item_discount]
    self.spend_threshold = args[:spend_threshold]
    self.qty_threshold = args[:qty_threshold]
  end

  # Imports rule sets from a local YAML file.
  def self.import(file = 'lib/rules.yml')
    rules = YAML.load_file(file)['rules']
    rules.map{|rule| Rule.new(rule) }
  end

  # Applies the rule to the given total, dependent on the checkout items received
  def apply_to(total, items)
    if valid_for?(items)
      if per_item_discount
        return total - per_item_discount * valid_items(items).length
      elsif percent_discount
        if product_code
          return total - valid_items(items).map{|item| item.price * percent_discount }.reduce(&:+)
        else
          return total * (1 - percent_discount)
        end
      end
    end
    total
  end

  # Verifies whether the rule conditions match the list of items
  def valid_for?(items)
    return false if qty_threshold && valid_items(items).count < qty_threshold
    return false if spend_threshold && valid_items(items).map(&:price).reduce(&:+) < spend_threshold
    true
  end

  def valid_items(items)
    product_code ? items.select{|item| item.product_code == product_code } : items
  end
end
