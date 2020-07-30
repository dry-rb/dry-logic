---
title: Introduction
description: Predicate logic with composable rules
layout: gem-single
type: gem
name: dry-logic
sections:
  - predicates
  - operations
---

Predicate logic and rule composition used by:

* [dry-types](https://github.com/dry-rb/dry-types) for constrained types
* [dry-validation](https://github.com/dry-rb/dry-validation) for composing validation rules
* your project...?

## Synopsis

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

# Rule::Predicate will only apply its predicate to its input, that’s all

# require input to have the key :user
user_present = Rule::Predicate.new(Predicates[:key?]).curry(:user)
# curry allows us to prepare predicates with args, without the input

# require value to be greater than 18
min_18 = Rule::Predicate.new(Predicates[:gt?]).curry(18)

# use the min_18 predicate on the value of user[:age]
has_min_age = Operations::Key.new(min_18, name: [:user, :age])

user_rule = user_present & has_min_age

user_rule.(user: { age: 19 }).success?
# => true

user_rule.(user: { age: 18 }).success?
# => false

user_rule.(user: { age: 'seventeen' })
# => ArgumentError: comparison of String with 18 failed

user_rule.(user: { })
# => NoMethodError: undefined method `>' for nil:NilClass

user_rule.({}).success?
# => false
```
