---
title: Predicates
layout: gem-single
name: dry-logic
---

## URI

> Verify user input is a URL

``` ruby
is_https_url = build { uri?(:https) }
is_https_url = build { uri?(/https?/) }
is_http_url = build { uri?(:http) }
is_url = build { uri?([:http, :https]) }

https_url = "https://example.com"
http_url = "http://example.com"
local_url = "example.local"

is_https_url.call(https_url).success? # => true
is_https_url.call(local_url).success? # => false
is_http_url.call(http_url).success? # => true
is_url.call(https_url).success? # => false
```

## UUID (1-5)

> Verify user input against UUID 1-5

``` ruby
is_uuid_v1 = build { uuid_v1? }
is_uuid_v2 = build { uuid_v2? }
is_uuid_v3 = build { uuid_v3? }
is_uuid_v4 = build { uuid_v4? }
is_uuid_v5 = build { uuid_v5? }

uuid1 = "554ef240-5433-11eb-ae93-0242ac130002"
not_uuid = "<not uuid>"

is_uuid_v1.call(uuid1).success? # => true
is_uuid_v2.call(uuid1).success? # => false
is_uuid_v3.call(not_uuid).success? # => false
is_uuid_v4.call(uuid1).success? # => false
is_uuid_v5.call(uuid1).success? # => false
```

## Case expression

> Implements Ruby's `===` operator

``` ruby
is_natrual = build { case?(1...) }

is_natrual.call(1).success? # => true
is_natrual.call(-1).success? # => false
is_natrual.call("<string>").success? # => false

is_integer = build { case?(Integer) }

is_integer.call(1).success? # => true
is_integer.call("<string>").success? # => false
```

## Identity equality

> Compare two values using `object_id`

``` ruby
is_nil = build { is?(nil) }

is_nil.call(nil).success? # => true
is_nil.call(:some).success? # => false

is_very_specific = build { is?(Class.new) }

is_very_specific.call(nil).success? # => false
is_very_specific.call(:some).success? # => false
```

## Equality

> Implements Ruby's `==` operator

``` ruby
is_zero = build { eql?(0) }

is_zero.call(0).success? # => true
is_zero.call(10).success? # => false
```

## Inequality

``` ruby
is_present = build { not_eql?(nil) }

is_not_zero.call("hello").success? # => true
is_not_zero.call(nil).success? # => false
```

## Included values

> Check for inclusion. Can be used on all values responding to `include?`

``` ruby
has_zeros = build { includes?(0) }

has_nils.call([0, 1, 2]).success? # => true
has_nils.call([-1, -2, -3]).success? # => false
```

## Excluded values

> Inverse of `includes?`

``` ruby
no_zeroes = build { excludes?(0) }

no_zeroes.call([1,2,3]).success? # => true
no_zeroes.call([0, -1, -2]).success? # => false
```

## Included in

> Check for inclusion. Can be used on all values responding to `include?`

``` ruby
is_natrual = build { included_in?(1...) }

is_natrual.call(1).success? # => true
is_natrual.call(0).success? # => false
is_natrual.call(-1).success? # => false
```

## Excluded from

> Inverse of `included_in?`

```
is_negative = build { excluded_from?(0...) }

is_negative.call(-1).success? # => true
is_negative.call(0).success? # => false
is_negative.call(1).success? # => false
```

## Size

> Can be applied to all values implementing `#size`, such as `Hash`, `Array`, and `String`.

``` ruby
is_empty = build { size?(0) }

is_empty.call({}).success? # => true
is_empty.call([]).success? # => true
is_empty.call("").success? # => true

is_empty.call({"1" => 2}).success? # => false
is_empty.call([1]).success? # => false
is_empty.call("1").success? # => false
```

## Minimum size

> Checks for a miminum size using `#size >= value`. See #size?

``` ruby
is_present = build { min_size?(1) }

is_present.call({"1" => 2}).success? # => true
is_present.call([1]).success? # => true
is_present.call("1").success? # => true

is_present.call({}).success? # => false
is_present.call([]).success? # => false
is_present.call("").success? # => false
```

## Maximum size

> Checks for a maximum size using `#size <= value`. See #size?

``` ruby
one_or_none = build { max_size?(1) }

one_or_none.call({}).success? # => true
one_or_none.call([1]).success? # => true
one_or_none.call("A").success? # => true

one_or_none.call({"A" => :a, "B" => :b}).success? # => false
one_or_none.call([1,2]).success? # => false
one_or_none.call("AB").success? # => false
```

## Bytesize

> Same as `size?` but uses [String#bytesize](https://www.rubydoc.info/stdlib/core/String:bytesize) instead of `size`

``` ruby
is_one = build { bytesize?(1) }

is_one.call("A").success? # => true
is_one.call("AB").success? # => false

is_two_or_tree = build { bytesize?(2..3) }

is_two_or_tree.call("ABC").success? # => true
is_two_or_tree.call("ABCD").success? # => false

is_four = build { bytesize?([4]) }

is_four.call("ABCD").success? # => true
is_four.call("ABC").success? # => false
```

## Minimum byte size

> Same as `min_size?` but uses [String#bytesize](https://www.rubydoc.info/stdlib/core/String:bytesize) instead of `size`

``` ruby
is_min_one = build { min_bytesize?(1) }

is_min_one.call("A").success? # => true
is_min_one.call("").success? # => false
```

## Maximum byte size

> Same as `max_size?` but uses [String#bytesize](https://www.rubydoc.info/stdlib/core/String:bytesize) instead of `size`

``` ruby
is_max_one = build { max_bytesize?(1) }

is_max_one.call("A").success? # => true
is_max_one.call("AB").success? # => false
```

## Greater than

> Implements Ruby's greater than `>` operator

``` ruby
can_vote = build { gt?(17) }

can_vote.call(17).success? # => false
can_vote.call(18).success? # => true
can_vote.call(19).success? # => true
```

## Greater or equal to

> Implements Ruby's greater than `>=` operator

``` ruby
can_vote = build { gteq?(18) }

can_vote.call(17).success? # => false
can_vote.call(18).success? # => true
can_vote.call(19).success? # => true
```

## Less than

> Implements Ruby's less than `<` operator

``` ruby
can_work = build { lt?(65) }

can_work.call(65).success? # => false
can_work.call(64).success? # => true
```

## Less or equal to

> Implements Ruby's less than `<=` operator

``` ruby
can_work = build { lteq?(64) }

can_work.call(65).success? # => false
can_work.call(64).success? # => true
```

## Odd

> Implements Ruby's `Integer#odd?` method

``` ruby
is_odd = build { odd? }

is_odd.call(1).success? # => true
is_odd.call(2).success? # => false
```

## Even

> Implements Ruby's `Integer#even?` method

``` ruby
is_even = build { even? }

is_even.call(2).success? # => true
is_even.call(1).success? # => false
```

## Hash

> Checks if the input is of type `Hash`

``` ruby
is_hash = build { hash? }

is_hash.call(Hash.new).success? # => true
is_hash.call(Array.new).success? # => false
```

## Array

> Checks if the input is of type `Array`

``` ruby
is_array = build { array? }

is_array.call(Array.new).success? # => true
is_array.call(Hash.new).success? # => false
```

## String

> Checks if the input is of type `String`

``` ruby
is_string = build { str? }

is_string.call(String.new).success? # => true
is_string.call(Hash.new).success? # => false
```

## Number

> Checks if a value can be typecast into a number

``` ruby
is_number = build { number? }

is_number.call(4).success? # => true
is_number.call(-4).success? # => true
is_number.call("  4").success? # => true
is_number.call("-4").success? # => true
is_number.call(4.0).success? # => true
is_number.call('4').success? # => true
is_number.call('4.0').success? # => true

is_number.call("A4").success? # => false
is_number.call("A-4").success? # => false
is_number.call(nil).success? # => false
is_number.call(:four).success? # => false
is_number.call("four").success? # => false
```

## Decimal

> Checks if the input is of type `BigDecimal`

``` ruby
is_decimal = build { decimal? }

is_decimal.call(BigDecimal(1)).success? # => true
is_decimal.call(1).success? # => false
```

## Float

> Checks if the input is of type `Float`

``` ruby
is_float = build { float? }

is_float.call(1.0).success? # => true
is_float.call(1).success? # => false
```

## Integer

> Checks if the input is of type `Integer`

``` ruby
is_num = build { num? }

is_num.call(1).success? # => true
is_num.call(1.0).success? # => false
```

## Time

> Checks if the input is of type `Time`

``` ruby
is_time = build { time? }

is_time.call(Time.new).success? # => true
is_time.call("2 o'clock").success? # => false
```

## DateTime

> Checks if the input is of type `DateTime`

``` ruby
is_date_time = build { date_time? }

is_date_time.call(DateTime.new).success? # => true
is_date_time.call("2 o'clock").success? # => false
```

## Date

> Checks if the input is of type `Date`

``` ruby
is_date = build { date? }

is_date.call(Date.new).success? # => true
is_date.call("1 year ago").success? # => false
```

## Bool

> Checks if the input is of type `TrueClass` or `FalseClass`

``` ruby
is_bool = build { bool? }

is_bool.call(true).success? # => true
is_bool.call(false).success? # => true

is_bool.call(:false).success? # => false
is_bool.call("true").success? # => false
```

## True / False

> Check for a boolean value

``` ruby
is_true = build { true? }
is_false = build { false? }

is_true.call(true).success? # => true
is_true.call(false).success? # => false
is_false.call(false).success? # => true
is_true.call(true).success? # => false
```

## Empty

> Checks if a value is empty?

``` ruby
is_empty = build { empty? }

is_empty.call(nil).success? # => true
is_empty.call([]).success? # => true
is_empty.call("").success? # => true
is_empty.call({}).success? # => true

is_empty.call({key: :value}).success? # => false
is_empty.call([:array]).success? # => false
is_empty.call("string").success? # => false
is_empty.call(:symbol).success? # => false
```

## Filled

> Checks if a value is present? (not empty)

``` ruby
is_filled = build { filled? }

is_filled.call({key: :value}).success? # => true
is_filled.call([:array]).success? # => true
is_filled.call("string").success? # => true
is_filled.call(:symbol).success? # => true

is_filled.call(nil).success? # => false
is_filled.call([]).success? # => false
is_filled.call("").success? # => false
is_filled.call({}).success? # => false
```

## Attribute

> Implements Ruby's `respond_to?` method. Aliased to `respond_to?`

``` ruby
has_named = build { attr?(:name) }

class Person < Struct.new(:age, :name)
  # Logic ...
end

class Car < Struct.new(:age, :brand)
  # Logic ...
end

is_named.call(Person.new(30, "John")).success? # => true
is_named.call(Car.new(3, "Volvo")).success? # => false
```

## Nil

> Checks if the input is nil using `nil?`. Aliased to `none?`

``` ruby
is_nil = build { nil? }

is_nil.call(nil).success? # => true
is_nil.call(:some).success? # => false
```

## Key

> Checks if the input of type `Hash` contains the provided key

``` ruby
is_named = build { key?(:name) }

is_named.call({ name: "John" }).success? # => true
is_named.call({ age: 30 }).success? # => false
```

## Format

> Checks if the regular expression matches the input

``` ruby
is_email_ish = build { format?(/^\S+@\S+$/) }

is_email_ish.call("hello@example.com") # => true
is_email_ish.call("nope|failed.com") # => false
```
