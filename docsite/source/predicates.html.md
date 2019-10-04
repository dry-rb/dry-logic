---
title: Predicates
layout: gem-single
name: dry-logic
---

Dry-logic comes with a lot predicates to compose multiple rules:

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic
```

Now you can access all built-in predicates:

``` ruby
Predicates[:key?]
=> #<Method: Module(Dry::Logic::Predicates::Methods)#key?>
```

In the end predicates return true or false.

```ruby
Predicates[:key?].(:name, {name: 'John'})
=> true
```

* Built-in:
  - `type?`
  - `none?`
  - `key?`
  - `attr?`
  - `empty?`
  - `filled?`
  - `bool?`
  - `date?`
  - `date_time?`
  - `time?`
  - `number?`
  - `int?`
  - `float?`
  - `decimal?`
  - `str?`
  - `hash?`
  - `array?`
  - `odd?`
  - `even?`
  - `lt?`
  - `gt?`
  - `lteq?`
  - `gteq?`
  - `size?`
  - `min_size?`
  - `max_size?`
  - `inclusion?`
  - `exclusion?`
  - `included_in?`
  - `excluded_from?`
  - `includes?`
  - `excludes?`
  - `eql?`
  - `not_eql?`
  - `true?`
  - `false?`
  - `format?`
  - `respond_to?`
  - `predicate`

With predicates you can build more composable and complex operations:
For example, let's say we want to check that a given input is a hash and has a specify key.

``` ruby
require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

is_hash = Rule::Predicate.new(Predicates[:type?]).curry(Hash)
=> #<Dry::Logic::Rule::Predicate predicate=#<Method: Module(Dry::Logic::Predicates::Methods)#type?> options={:args=>[:hash]}>
name_key = Rule::Predicate.new(Predicates[:key?]).curry(:name)
=> #<Dry::Logic::Rule::Predicate predicate=#<Method: Module(Dry::Logic::Predicates::Methods)#key?> options={:args=>[:name]}>

hash_with_key = is_hash & name_key
=> #<Dry::Logic::Operations::And rules=[#<Dry::Logic::Rule::Predicate predicate=#<Method: Module(Dry::Logic::Predicates::Methods)#type?> options={:args=>[:hash]}>, #<Dry::Logic::Rule::Predicate predicate=#<Method: Module(Dry::Logic::Predicates::Methods)#key?> options={:args=>[:name]}>] options={}>

hash_with_key.(name: 'John').success?
=> true

hash_with_key.(not_valid: 'John').success?
=> false

hash_with_key.([1,2]).success?
=> false
```
