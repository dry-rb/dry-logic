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

user_present = Rule::Predicate.new(Predicates[:key?]).curry(:user)
# here curry simply curries arguments, so we can prepare
# predicates with args without the input
# translating this into words: check the if input has the key `:user`

min_18 = Rule::Predicate.new(Predicates[:gt?]).curry(18)
# check the value is greater than 18

has_min_age = Operations::Key.new(min_18, name: [:user, :age])
# in this example the name options is been use for accessing
# the value of the input

user_rule = user_present & has_min_age

user_rule.(user: { age: 19 }).success?
# true

user_rule.(user: { age: 18 }).success?
# false

user_rule.(user: { age: 'seventeen' })
# ArgumentError: comparison of String with 18 failed

user_rule.(user: { })
# NoMethodError: undefined method `>' for nil:NilClass

user_rule.({}).success?
# false
```
