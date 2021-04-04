require "yaml"

class CartService
  attr_reader :catalog, :pricing_rules, :cart_items

  def initialize(pricing_rules)
    @cart_items = []
    @catalog = YAML.load_file("./data/available_products.yml")
    @pricing_rules = pricing_rules
  end

  def call(items)
    items_grouped = items_grouped(items)

    items_grouped.keys.each do |key|
      existing_pricing_rule = pricing_rules[key]&.keys&.first

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
    required_number_of_items = pricing_rules[product_id]["apply_free_units_discount"]["amount"]
    number_of_free_items = pricing_rules[product_id]["apply_free_units_discount"]["free"]

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
    required_number_of_items = pricing_rules[product_id]["apply_bulk_discount"]["amount"]

    if number_of_items >= required_number_of_items
      discount = pricing_rules[product_id]["apply_bulk_discount"]["discount"]
      applied_price = catalog[product_id]["price"] - discount
    end

    applied_price ||= catalog[product_id]["price"]

    add_items(product_id: product_id, number_of_items: number_of_items, price: applied_price)
  end

  # adds items to cart with specific price or price by catalog
  def add_items(product_id:, number_of_items:, price: catalog[product_id]["price"])
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