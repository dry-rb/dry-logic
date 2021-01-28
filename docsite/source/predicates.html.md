---
title: Predicates
layout: gem-single
name: dry-logic
---

## Respond to

> See `attr?`.

``` ruby
has_name = build do
  respond_to?(:name)
end

person = Struct.new(:name).new("John")
age = Struct.new(:age).new(100)

has_name.call(person).success? # => true
has_name.call(age).success? # => false
```

## URI

> Verify user input is a URL.

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

> Implements the `===` operator

``` ruby
is_natrual = build { case?(1...) }
is_integer = build { case?(Integer) }

natrual = 10
negative = -1
string = "<string>"

is_natrual.call(natrual).success? # => true
is_natrual.call(negative).success? # => false
is_natrual.call(string).success? # => false
is_integer.call(natrual).success? # => true
is_integer.call(string).success? # => false
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

## Identity equality

> Compare two values using `object_id`

``` ruby
is_nil = build { is?(nil) }
is_very_specific = build { is?(Class.new) }
```

``` ruby
is_nil.call(nil).success? # => true
is_very_specific.call(nil).success? # => false
```

## Equality

> Implements Rubys compare operator `==` or `eql?`

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

> See `includes?`

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

> See `included_in?`

```
is_negative = build { excluded_from?(0...) }

is_negative.call(-1).success? # => true
is_negative.call(0).success? # => false
is_negative.call(1).success? # => false
```

## Bytesize

``` ruby
bytesize?(1)
bytesize?(2..3)
bytesize?([2, 3])
```

``` ruby
# Pass
"A"
"AB"
"AB"

# Fail
"AB"
"A"
"A"
```

## Max byte size

``` ruby
max_bytesize?(1)
```

``` ruby
# Pass
""

# Fail
"AB"
```

## Min byte size

``` ruby
min_bytesize?(1)
```

``` ruby
# Pass
"AB"

# Fail
""
```

## Min size

``` ruby
min_size?(2)
```

``` ruby
# Pass
[1, 2, 3]

# Fail
[1, 2]
```

## Max size

``` ruby
max_size?(2)
```

``` ruby
# Pass
[1]

# Fail
[1,2]
```

## Size

``` ruby
size?(2)
```

``` ruby
# Pass
[1, 2]

# Fail
[1]
```

## Greater or equal to

``` ruby
gteq?(10)
```

``` ruby
# Pass
11

# Fail
9
```

## Less or equal to

``` ruby
lteq?(10)
```

``` ruby
# Pass
9

# Fail
11
```


## Greater than

``` ruby
gt?(10)
```

``` ruby
# Pass
200

# Fail
5
```

## Less than

``` ruby
lt?(10)
```

``` ruby
# Pass
5

# Fail
200
```

## Odd

``` ruby
odd?
```

``` ruby
# Pass
5

# Fail
2
```

## Even

``` ruby
even?
```

``` ruby
# Pass
2

# Fail
5
```

## Hash

> Checks if input is of type `Hash`

``` ruby
hash?
```

``` ruby
# Pass
{ a: "B" }

# Fail
[1, 2, 3]
```

## Array

> Checks if the input is of type `Array`

``` ruby
array?
```

``` ruby
# Pass
[1, 2, 3]

# Fail
{ a: "B" }
```

## String

``` ruby
str?
```

``` ruby
# Pass
"hello"

# Fail
:world
```

## Decimal

> Checks if input type is `BigDecimal`

``` ruby
decimal?
```

``` ruby
# Pass
BigDecimal(1)

# Fail
1
```

## Float

> Checks if input type is `Float`

``` ruby
float?
```

``` ruby
# Pass
10.0

# Fail
100
```

## Integer

> Checks if input type is `Integer`

``` ruby
int?
```

``` ruby
# Pass
10

# Fail
10.0
```

## Number

> Checks if a value can be typecast into a number

``` ruby
number?
```

``` ruby
# Pass
-4
"    4"
"-4"
4.0
4
'4'
'4.0'

# Fail
"A-4"
"A4"
nil
:symbol
```

## Time

> Checks if the input is of type `Time`

``` ruby
time?
```

``` ruby
# Pass
Time.new

# Fail
:symbol
```

## DateTime

> Checks if the input is of type `DateTime`

``` ruby
date_time?
```

``` ruby
# Pass
DateTime.new

# Fail
:symbol
```

## Date

> Checks if the input is of type `Date`

``` ruby
date?
```

``` ruby
# Pass
Date.new

# Fail
:symbol
```

## Bool

> Checks if input is `true` or `false`

``` ruby
bool?
```

``` ruby
# Pass
true
false

# Fail
:symbol
```

## Filled

> Checks if the input is not empty

``` ruby
filled?
```

``` ruby
# Pass
[1,2]
"string"
{ key: "value" }
nil

# Fail
[]
""
{}
```

## Empty

> Checks if the input is empty

``` ruby
empty?
```

``` ruby
# Pass
[]
""
{}

# Fail
[1,2]
"string"
{ key: "value" }
nil
```

## Attribute

> Checks if an object responds to a certain method. Uses `respond_to?` to check the input.

``` ruby
attr?(:name)
```

``` ruby
# Pass
Struct.new(:name).new("John")

# Fail
Struct.new(:age).new(50)
```

## Nil

> Checks if the input is nil using `nil?`. Aliased to `none?`

``` ruby
nil?
none?
```

``` ruby
# Pass
nil

# Fail
:symbol
```

## Key

> Checks if the input of type `Hash` contains the provided key.

``` ruby
key?(:name)
```

``` ruby
# Pass
{ name: "John" }

# Fail
{ age: 50 }
```

## Format

> Applies a regular expression to its input

``` ruby
format?(/^(A|B)$/)
```

``` ruby
# Pass
"A"
"B"

# Fail
"C"
"D"
```
