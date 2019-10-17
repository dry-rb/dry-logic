---
title: Operations
layout: gem-single
name: dry-logic
---

Dry-logic uses operations to interact with the input passed to the different rules.

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Predicate.new(Predicates[:key?]).curry(:user)

min_18 = Rule::Predicate.new(Predicates[:gt?]).curry(18)

# Here Operations::Key and Rule::Predicate are use to compose and logic based on the value of a given key e.g [:user, :age]
has_min_age = Operations::Key.new(min_18, name: [:user, :age])
# => #<Dry::Logic::Operations::Key rules=[#<Dry::Logic::Rule::Predicate predicate=#<Method: Module(Dry::Logic::Predicates::Methods)#gt?> options={:args=>[18]}>] options={:name=>[:user, :age], :evaluator=>#<Dry::Logic::Evaluator::Key path=[:user, :age]>, :path=>[:user, :age]}>

# Thanks to the composable structure of the library we can use multiple Rules and Operations to create custom logic
user_rule = user_present & has_min_age

user_rule.(user: { age: 19 }).success?
# => true
```

* Built-in:
  - `and`
  - `or`
  - `key`
  - `attr`
  - `binary`
  - `check`
  - `each`
  - `implication`
  - `negation`
  - `set`
  - `xor`

Another example, lets create the `all?` method from the `Enumerable` module.

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

def all?(value)
  Operations::Each.new(Rule::Predicate.new(Predicates[:gt?]).curry(value))
end

all_6 = all?(6)

all_6.([6,7,8,9]).success?
# => true

all_6.([1,2,3,4]).success?
# => false
```
