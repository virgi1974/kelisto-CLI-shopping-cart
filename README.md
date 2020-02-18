<h1 align="center">Backend Ruby Challenge</h1>
<div align="center">
  <div>
    <a style="margin-right: 8px;" href="https://github.com/kelkoo-services/kelisto-backend-ruby-challenge/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square" /></a>
  </div>
  </br>
</div>

## ✨  Introduction

Welcome to the coding challenge for developers interested in **backend** roles in Kelisto. It's not an against-the-clock time challenge - you can complete it at home in your own time.

Ideally you will return your submission in __within 2 days__ - the sooner you get your submission back to us, the more quickly we can progress your application to interview stage. Based on previous candidate experiences, we believe **it will take you between 1 to 2 hours to complete the challenge.**

## The Challenge

Build a Checkout Cart. It consists in:

  - [Modeling business rules](#modeling-business-rules).

## Modeling business rules

- Implement a check-out system that fulfills business requirements.

> We expect only **plain classes and objects** to solve the challenge. Add files for your solution to the `src` folder.

### Business requirements

- [ ] Build a check-out system.
- [ ] Our check-out let us to scan items.
- [ ] Our check-out can calculate the total price of those scanned items.
- [ ] We sell only three kind of items:

| Item code | Name | Price |
|:---:|---|---:|
| GR1 | Green tea | £3.11 |
| SR1 | Strawberries | £5.00 |
| CF1 | Coffee | £11.23 |

- [ ] Our check-out support receiving different pricing rules to handle different discounts depending on the scanned items. These are the pricing rules:
  - `buy-one-get-one-free` offers and of green tea.
  - Buying strawberries to get a price discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50.
- [ ] Our check-out can scan items in any order, and because the product team change their minds often, it needs to be flexible regarding our pricing rules.

#### Usage

- The interface to our check-out looks like this:

```js
const co = new Checkout(pricing_rules)

co.scan(item)
co.scan(item)

const price = co.total
```

#### Test data

```
Basket: GR1,SR1,GR1,GR1,CF1
Total price expected: £22.45

Basket: GR1,GR1
Total price expected: £3.11

Basket: SR1,SR1,GR1,SR1
Total price expected: £16.61
```

## 🎁 Bonus Round (not required but nice-to-have)

- Add unit tests
- Dockerize the app
- Surprise us…

## 👎 What we do not like

- Frameworks 😊 (you don't need to use any; just use plain `ruby`).
- Metaprogramming.

## 💯 How we're evaluating the result

Prioritised from most important to least important, here's our evaluation criteria:

- __Code Quality.__ Is the code clean, well-structured and easy to understand?
- __Architecting.__ Did you isolate responsabilities? Did you use any software pattern?
- __UI/UX.__ Is the app working well on both desktop and mobile?
- __Testing.__ Did you write tests?
- __The extra mile.__ Did you document your solution? ([use the `ABOUT.md` file](https://github.com/kelkoo-services/kelisto-backend-ruby-challenge/blob/master/ABOUT.md))

You do not need to hit all points, but obviously, the more the better :)

## 🚀 Project submitting

To send us your code, you can:

- Make a fork of this repository, and send us a pull-request;
- or give access to your repository in Github/Bitbucket.

## 🤘 What’s next?

Once you submit your solution, our team will review your code challenge, taking your experience level into account. The sample code provided by you should be in a state considered as a "production" ready - where each requested element is prepared and potentially ready to review with your colleagues.

Good luck!

**“The Challenge” has been created with the sole intention of being used as a guiding document for the current recruitment process. This means we won't be using it (all or parts of it) within our projects.**
