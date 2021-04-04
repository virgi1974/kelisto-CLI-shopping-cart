require "yaml"

class CartService
  attr_reader :pricing_rules, :cart_items

  def initialize(pricing_rules)
    @cart_items = []
    @pricing_rules = pricing_rules
  end

  def call(items)
    items_grouped = items_grouped(items)

    items_grouped.keys.each do |key|
      existing_pricing_rule = pricing_rules[key]["rule"]&.first&.first

      case existing_pricing_rule
      when "apply_free_units_discount"
        apply_free_units_discount(product_id: key, number_of_items: items_grouped[key])
      when "apply_bulk_discount"
        apply_bulk_discount(product_id: key, number_of_items: items_grouped[key])
      else
        add_items(product_id: key, number_of_items: items_grouped[key])
      end
    end
    
    cart_items.inject (0.0) { |sum, item| sum + item.values[0] }
  end
  
  private
  
  # adds extra free items
  def apply_free_units_discount(product_id: ,number_of_items:)
    rule_to_apply = pricing_rules[product_id]["rule"]["apply_free_units_discount"]
    required_number_of_items = rule_to_apply["required_number_of_items"]
    number_of_free_items = rule_to_apply["free_items"]
    
    total = [product_id]*number_of_items
    normal = []
    with_discount = []
    
    while total.size != 0
      normal << total.shift(required_number_of_items)
      with_discount << total.shift(number_of_free_items)
    end
    
    # items with regular price
    add_items(product_id: product_id, number_of_items: normal.flatten.size)
    # items with free price
    add_items(product_id: product_id, number_of_items: with_discount.flatten.size, price: 0.0)
  end
  
  # applies bulk discount when matching criteria
  def apply_bulk_discount(product_id: ,number_of_items:)
    rule_to_apply = pricing_rules[product_id]["rule"]["apply_bulk_discount"]

    if number_of_items >= rule_to_apply["required_number_of_items"]
      discount = rule_to_apply["discount"]
      applied_price = pricing_rules[product_id]["price"] - discount
    end

    applied_price ||= pricing_rules[product_id]["price"]

    add_items(product_id: product_id, number_of_items: number_of_items, price: applied_price)
  end

  # adds items to cart with specific price or price by pricing_rules
  def add_items(product_id:, number_of_items:, price: pricing_rules[product_id]["price"])
    number_of_items.times do
      cart_items << {"#{product_id}": price}
    end
  end

  # hash with product_id as key and number of scaned items as value
  def items_grouped(items)
    items.inject(Hash.new(0)) do |h, value|
      h[value] += 1
      h
    end
  end
  
end