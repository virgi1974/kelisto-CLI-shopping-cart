# SCANNING ITEMS FOR A CART 🛒

Basic CLI app to scan items.  
The idea is to have a simple interface.  
As required, no frameworks or metaprogramming have been used.  
The only library used has been `tty-prompt` in order to get a prettier CLI.

### Dependencies 🕸️

The only dependency is the Ruby version itself when trying a local setup.

- Ruby version. 2.7.0

There is also a dockerized version, for which the only required software to run the app is `Docker`.

### Installation

We need first to clone the repo.

#### With Docker 🐳

To get the app running in containers.

1. Install Docker
2. Run `docker-compose build`. This will start two containers where the app will be running.
3. Once it is finished we just run the `scanner` container which triggers the CLI  
   `docker-compose run --rm scanner`

#### With local setup 💎

To get the app running in containers.

1. Run `bundle install` to install dependencies.
2. The file to execute is inside the `cd /src` folder.
3. Trigger the CLI app with `ruby scanner.rb`

### Data 📖

The data related to the pricing for the different items has been set in a `yml` file `/src/data/pricing_rules.yml`.  
We assume a structure in which we find the id's for the active items, plus all the needed info such as

- name
- price
- rule (special bussiness rule to apply under certain conditions for this item)

using this kind of structure

```
GR1:
  name: Green tea
  price: 3.11
  rule:
    apply_free_units_discount:
      required_number_of_items: 1
      free_items: 1
...
```

### Interface 🪟

**Scanner** - the file in charge of triggering the app and showing the menu.  
**CartService** - Service Object in charge of the calculations (only one public method `call` exposed)

### Usage

When using the dockerized version just run **`docker-compose run --rm scanner`**  
When using local installation just run **`ruby scanner.rb`**

![](https://user-images.githubusercontent.com/13310108/113519072-4aecf200-958a-11eb-97da-5486b73fb790.png)

Interface is easy, just go up ⬆️ and down 🔽 using the the arrow keys and pressing enter to add it to the cart.  
Once finished we finish the process by selecting the option `*** EXIT ***`.

If the process finishes correctly something like `Total price expected: £19.34` will be printed.  
In case there was some error during the process a generic message will be shown `####### There was an error during the checkout #######`.

### Testing ⛑️

The test suite can be run by using the command **`bundle exec rspec`**.  
It can be run also on the `scanner` container with **`docker-compose run --rm scanner bundle exec rspec`**  
Gem `Simplecov` was added to ensure full coverage.

![](https://user-images.githubusercontent.com/13310108/113519023-17aa6300-958a-11eb-9c9a-b6a8fe126d5a.png)

#### How would you improve your solution? What would be the next steps? 💡

- The method `#def items_grouped(items)` should have been moved to something like `/src/lib/utilities.rb` since it is not related to the cart logic itself.
- I made the assumption that each item can has only one rule to be applied, though in a real scenario I guess several rules could be applied for the same item, in a specific given order. So that is something to be improved.
- Validation of the `yml` file to check the data type of all the different fields (thinking of somebody sending wrong file with missing or incorrect data). I guess it was a bit out of the scope of the task.
- Didn't get the time to play a lot with the `tty-prompt` GEM though it seems to be very configurable. I could have accomplished a prettier interface.
- Didn't get the time to add a feature to delete already scanned items, I guess it would be one of the next steps.
- One thought that came to my mind a couple of times was to do just one apply_discount method, combining both the ones I made. It could have been done but some cornercases made me not to do it. Still not sure if that was feasible and a better approach.
- The test suite could be refactored, since many examples use similar code to mock the different scenarios.
- Tried a couple of things to test the CLI itself but couldn't make it work since it hangs waiting for user input.
