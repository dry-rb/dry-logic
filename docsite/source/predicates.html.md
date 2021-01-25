---
title: Predicates
layout: gem-single
name: dry-logic
---

## Respond to

> See `attr?`.

``` ruby
respond_to?(:name)
```

``` ruby
# Pass
Struct.new(:name).new("John")

# Fail
Struct.new(:age).new(100)
```

## URI

> Verify user input is a URL.

``` ruby
uri?(:https)
uri?(:http)
uri?(/https?/)
uri?([:http, :https])
```

``` ruby
# Pass
"https://google.com"

# Fail
"localhost"
```

## UUID (1-5)

> Verify user input against UUID 1-5

``` ruby
uuid_v1?
uuid_v2?
uuid_v3?
uuid_v4?
uuid_v5?
```

``` ruby
# Pass UUID-1
"554ef240-5433-11eb-ae93-0242ac130002"

# Fail
"localhost"
```

## Case? (`===`)

> Implements the `===` operator

``` ruby
case?(5..10)
case?(Integer)
```

``` ruby
# Pass
10
1

# Fail
100
"string"
```

## Bool (`true`/ `false`)

> Check for a boolean value

``` ruby
true?
false?
```

``` ruby
# Pass
true
false

# Fail
false
true
```

## `is?` Equality `equal?`

> Compare two values using `object_id`

``` ruby
is?(nil)
is?(Class.new)
```

``` ruby
# Pass
nil

# Fail
Class.new
```

## Inequality (`not_equal?`)

``` ruby
not_eql?(10)
```

``` ruby
# Pass
20

# Fail
10
```

## Equality (value) (`eql?`)

> Implements Rubys compare operator `==` or `eql?`

``` ruby
eql?(10)
```

``` ruby
# Pass
10

# Fail
20
```

## Excluded values

> Check for exclusion. Can be used on all values responding to `include?`

``` ruby
excludes?("A")
excludes?(5)
```

``` ruby
# Pass
"BBB"
[1, 2, 3]

# Fail
"AAA"
[3, 4, 5]
```

## Included values

> Check for exclusion. Can be used on all values responding to `include?`

``` ruby
includes?("A")
includes?(5)
```

``` ruby
# Pass
"AAA"
[3, 4, 5]

# Fail
"BBB"
[1, 2, 3]
```

## Excluded from

``` ruby
excluded_from?([1, 2, 3])
```

``` ruby
# Pass
4

# Fail
1
```

## Included in

``` ruby
included_in?([1, 2, 3])
```

``` ruby
# Pass
1

# Fail
4
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

## String?

``` ruby
str?
```

``` ruby
# Pass
"hello"

# Fail
:world
```

## Decimal?

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
