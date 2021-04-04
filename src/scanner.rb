require "tty-prompt"
require "pry"
require "yaml"
require './cart_service.rb'

pricing_rules = YAML.load_file("./data/pricing_rules.yml")

prompt = TTY::Prompt.new
cart_service = CartService.new(pricing_rules           )
products = {}
cart_items = []                                         
finishing = 0

cart_service.catalog.each {|entry| products[entry[1]["name"]] = entry[0]}
products.merge!({"*** EXIT ***": 1})

prompt.say("select the **finish** option once finished")

while finishing == 0
  product = prompt.select("Choose products", products)
  
  if product == 1
    finishing = 1 
  else
    cart_items << product
  end
end

# cart_service.items << product unless product == 1
result = cart_service.call(cart_items)

prompt.ok("Total price expected: #{result}")
prompt.ok("---------------------")
# prompt.ok(cart_items)
