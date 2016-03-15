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

user_present = Rule::Key.new(Predicates[:key?], name: :user)

has_min_age = Rule::Key.new(
  Predicates[:key?]) & Rule::Value.new(:age, Predicates[:gt?].curry(18),
  name: :age
)

user_rule = user_present & has_min_age

user_rule.(user: { age: 19 })
# #<Dry::Logic::Result::Value success?=true input=19 rule=#<Dry::Logic::Rule::Value name=:age predicate=#<Dry::Logic::Predicate id=:gt?>>>

user_rule.(user: { age: 18 })
# #<Dry::Logic::Result::Value success?=false input=18 rule=#<Dry::Logic::Rule::Value name=:age predicate=#<Dry::Logic::Predicate id=:gt?>>>
```

## License

See `LICENSE` file.
