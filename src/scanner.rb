#!/usr/bin/env ruby

require "tty-prompt"
require "yaml"
require './cart_service.rb'

# cart service initialization with active pricing rules
pricing_rules = YAML.load_file("./data/pricing_rules.yml")
cart_service = CartService.new(pricing_rules)

# composes the menu for CLI
products = {}
cart_service.pricing_rules.each {|entry| products[entry[1]["name"]] = entry[0]}
products.merge!({"*** EXIT ***": 1})

cart_items = []                                         
finishing = 0

prompt = TTY::Prompt.new
prompt.warn("select the *** EXIT *** option once finished")
puts "\n"

while finishing == 0
  product = prompt.select("Choose products", products)
  
  if product == 1
    finishing = 1 
  else
    cart_items << product
  end
end

result = cart_service.call(cart_items)

puts "\n"

if result[:ok] == true
  prompt.ok("---------------------")
  prompt.ok("Total price expected: £#{result[:total_price]}")
  prompt.ok("---------------------")
else
  prompt.error("####### There was an error during the checkout #######")
end



