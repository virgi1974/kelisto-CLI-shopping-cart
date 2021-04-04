require 'pry'
require "yaml"
require "./cart_service.rb"

describe CartService do
  let!(:pricing_rules) do
    YAML.load_file("./spec/support/data/pricing_rules.yml")
  end

  context "pricing rules content" do
    it "has expected keys" do
      # keys with name & price 
      ["CF1"].each do |key|
        expect(pricing_rules[key].key?("name")).to be true
        expect(pricing_rules[key].key?("price")).to be true
        expect(pricing_rules[key].key?("rule")).to be false
      end
      # keys with name & price & rule
      ["GR1", "SR1"].each do |key|
        expect(pricing_rules[key].key?("name")).to be true
        expect(pricing_rules[key].key?("price")).to be true
        expect(pricing_rules[key].key?("rule")).to be true
      end
      # apply_free_units_discount keys
      expect(pricing_rules["GR1"]["rule"].key?("apply_free_units_discount")).to be true
      expect(pricing_rules["GR1"]["rule"]["apply_free_units_discount"].key?("required_number_of_items")).to be true
      expect(pricing_rules["GR1"]["rule"]["apply_free_units_discount"].key?("free_items")).to be true
      # apply_bulk_discount keys
      expect(pricing_rules["SR1"]["rule"].key?("apply_bulk_discount")).to be true
      expect(pricing_rules["SR1"]["rule"]["apply_bulk_discount"].key?("required_number_of_items")).to be true
      expect(pricing_rules["SR1"]["rule"]["apply_bulk_discount"].key?("discount")).to be true
    end
  end

  context "Cartservice response" do
    describe "returns a hash" do
      it "when successful" do
        cart_service = CartService.new(pricing_rules)
        response = cart_service.call([])
        expect(response.key?(:ok)).to be true
        expect(response[:ok]).to be true
        expect(response.key?(:total_price)).to be true
        expect(response[:total_price]).to be 0.00
      end

      it "when failure" do
        pricing_rules["GR1"]["price"] = "not valid type"
        cart_service = CartService.new(pricing_rules)
        response = cart_service.call(["GR1"])
        expect(response.key?(:ok)).to be true
        expect(response[:ok]).to be false
        expect(response.key?(:total_price)).to be true
        expect(response[:total_price]).to be nil
      end
    end
  end

  context "Cart empty" do
    it 'returns 0.0 price' do
      cart_service = CartService.new(pricing_rules)
      expect(cart_service.call([])[:total_price]).to eq(0.0)
    end
  end

  context "Cart with scanned items" do
    context "Item without special pricing rule" do
      describe "returns price"
        it "proportional to the number of scanned items" do
          number_of_items = rand(1..9)
          items = ["CF1"] * number_of_items
          random_price = rand(1.00..19.00).round(2)
          pricing_rules["CF1"]["price"] = random_price

          expected_price = (number_of_items * random_price).round(2)
          cart_service = CartService.new(pricing_rules)
          expect(cart_service.call(items)[:total_price]).to eq(expected_price)
        end
    end

    context "Item with special pricing rule" do
      describe "#apply_free_units_discount" do
        context "applies same price to all items" do
          it "when free_items = 0" do
            pricing_rules["GR1"]["rule"]["apply_free_units_discount"]["free_items"] = 0
            number_of_items = rand(1..9)
            items = ["GR1"] * number_of_items
            random_price = rand(1.00..19.00).round(2)
            pricing_rules["GR1"]["price"] = random_price
            
            expected_price = (number_of_items * random_price).round(2)
            cart_service = CartService.new(pricing_rules)

            expect(cart_service.call(items)[:total_price]).to eq(expected_price)
          end
          
          it "when required_number_of_items > scanned items" do
            number_of_items = rand(1..9)
            pricing_rules["GR1"]["rule"]["apply_free_units_discount"]["required_number_of_items"] = number_of_items + 1
            pricing_rules["GR1"]["rule"]["apply_free_units_discount"]["free_items"] = 1
            items = ["GR1"] * number_of_items
            random_price = rand(1.00..19.00).round(2)
            pricing_rules["GR1"]["price"] = random_price
            
            expected_price = (number_of_items * random_price).round(2)
            cart_service = CartService.new(pricing_rules)
            expect(cart_service.call(items)[:total_price]).to eq(expected_price)
          end
        end
        
        context "applies discount every x items" do
          it "when required_number_of_items < scanned items & free_items != 0" do
            rule = pricing_rules["GR1"]["rule"]["apply_free_units_discount"]
            expect(rule["required_number_of_items"]).to eq(1)
            expect(rule["free_items"]).to eq(1)
            pricing_rules["GR1"]["price"] = 10.21
            
            cart_service = CartService.new(pricing_rules)
            items = ["GR1"] * 2
            # ["GR1" 10.21] ["GR1" 0.00] 
            expect(cart_service.call(items)[:total_price]).to eq(10.21)
            
            cart_service_2 = CartService.new(pricing_rules)
            items = ["GR1"] * 3
            # ["GR1" 10.21] ["GR1" 0.00] ["GR1" 10.21]
            expect(cart_service_2.call(items)[:total_price]).to eq(10.21 * 2)
          end
        end
      end

      describe "#apply_bulk_discount" do
        context "not applying discount" do
          it "when scanned items less than required_number_of_items field" do
            rule = pricing_rules["SR1"]["rule"]["apply_bulk_discount"]
            expect(rule["required_number_of_items"]).to eq(3)
            expect(rule["discount"]).to eq(0.50)
            price = 7.55
            pricing_rules["SR1"]["price"] = price
                  
            cart_service = CartService.new(pricing_rules)
            items = ["SR1"] * 2
            # ["SR1" 7.55] ["SR1" 7.55] 
            expect(cart_service.call(items)[:total_price]).to eq(price * 2)
          end
        end

        context "applying discount" do
          it "when scanned items bigger than required_number_of_items field" do
            rule = pricing_rules["SR1"]["rule"]["apply_bulk_discount"]
            expect(rule["required_number_of_items"]).to eq(3)
            expect(rule["discount"]).to eq(0.50)
            price = 7.55
            pricing_rules["SR1"]["price"] = price
                  
            cart_service = CartService.new(pricing_rules)
            items = ["SR1"] * 4
            expected_price = price - 0.50
            # ["SR1" 7.05] ["SR1" 7.05] ["SR1" 7.05] ["SR1" 7.05]
            expect(cart_service.call(items)[:total_price]).to eq(expected_price * 4)
          end
        end
      end
    end
  end
end
