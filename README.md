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

# Rule::Predicate will only apply its predicate to its input, that’s all

user_present = Rule::Predicate.new(Predicates[:key?]).curry(:user)
# here curry simply curries arguments, so we can prepare
# predicates with args without the input
# translating this into words: check the the input has the key `:user`

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

puts user_rule.({}).success?
# false
```

## License

See `LICENSE` file.
