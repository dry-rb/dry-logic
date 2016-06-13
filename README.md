[gem]: https://rubygems.org/gems/dry-logic
[travis]: https://travis-ci.org/dry-rb/dry-logic
[gemnasium]: https://gemnasium.com/dry-rb/dry-logic
[codeclimate]: https://codeclimate.com/github/dry-rb/dry-logic
[coveralls]: https://coveralls.io/r/dry-rb/dry-logic
[inchpages]: http://inch-ci.org/github/dry-rb/dry-logic

# dry-logic [![Join the chat at https://gitter.im/dry-rb/chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dry-rb/chat)

[![Gem Version](https://badge.fury.io/rb/dry-logic.svg)][gem]
[![Build Status](https://travis-ci.org/dry-rb/dry-logic.svg?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/dry-rb/dry-logic.svg)][gemnasium]
[![Code Climate](https://codeclimate.com/github/dry-rb/dry-logic/badges/gpa.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/dry-rb/dry-logic/badges/coverage.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/dry-rb/dry-logic.svg?branch=master)][inchpages]

Predicate logic and rule composition used by:

* [dry-types](https://github.com/dry-rb/dry-types) for constrained types
* [dry-validation](https://github.com/dry-rb/dry-validation) for composing validation rules
* your project...?

## Synopsis

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Key.new(Predicates[:filled?], name: :user)

has_min_age = Rule::Key.new(Predicates[:int?], name: [:user, :age])
  & Rule::Key.new(Predicates[:gt?].curry(18), name: [:user, :age])

user_rule = user_present & has_min_age

user_rule.(user: { age: 19 })
# #<Dry::Logic::Result::Named success?=true input={:user=>{:age=>19}} rule=#<Dry::Logic::Rule::Key predicate=#<Dry::Logic::Predicate id=:gt? args=[18, 19]> options={:evaluator=>#<Dry::Logic::Evaluator::Key path=[:user, :age]>, :name=>[:user, :age]}>>

user_rule.(user: { age: 18 })
# #<Dry::Logic::Result::Named success?=false input={:user=>{:age=>18}} rule=#<Dry::Logic::Rule::Key predicate=#<Dry::Logic::Predicate id=:gt? args=[18, 18]> options={:evaluator=>#<Dry::Logic::Evaluator::Key path=[:user, :age]>, :name=>[:user, :age]}>>

user_rule.(user: { age: 'seventeen' }).inspect
#<Dry::Logic::Result::Named success?=false input={:user=>{:age=>"seventeen"}} rule=#<Dry::Logic::Rule::Key predicate=#<Dry::Logic::Predicate id=:int? args=["seventeen"]> options={:evaluator=>#<Dry::Logic::Evaluator::Key path=[:user, :age]>, :name=>[:user, :age]}>>

user_rule.(user: { }).inspect
#<Dry::Logic::Result::Named success?=false input={:user=>{}} rule=#<Dry::Logic::Rule::Key predicate=#<Dry::Logic::Predicate id=:filled? args=[{}]> options={:evaluator=>#<Dry::Logic::Evaluator::Key path=[:user]>, :name=>:user}>>

puts user_rule.({}).inspect
#<Dry::Logic::Result::Named success?=false input={} rule=#<Dry::Logic::Rule::Key predicate=#<Dry::Logic::Predicate id=:filled? args=[nil]> options={:evaluator=>#<Dry::Logic::Evaluator::Key path=[:user]>, :name=>:user}>>
```

## License

See `LICENSE` file.
