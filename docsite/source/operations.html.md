---
title: Operations
layout: gem-single
name: dry-logic
---

Operations work on one or more predicates (see predicates) and can be invoked in conjunction with other operations.

## Or

Alias: `|`, `or`

> Equivalent to Rubys `||` operator. Returns true if one of its arguments is true. Can be invoked using the `|` operator or the `or` method.

Argument 1 | Argument 2 | Result
--- | --- | ---
true | true | true
true | false | true
false | true | true
false | false | false

``` ruby
is_number = build do
  int? | float? | number?
end

is_number.call(1).success? # => true
is_number.call(2.0).success? # => true
is_number.call('3').success? # => false
is_number.call('four').success? # => false
```

### If "this" than "that"

Alias: `>`, `then`, `implication`

> Implication. Returns true if the first predicate fails or if the second predicate succeeds. Useful for doing pre-checks without affecting the overall predicate.

Argument 1 | Argument 2 | Result
--- | --- | ---
true | true | true
true | false | false
false | true | false
false | false | false

``` ruby
is_empty = build do
  (attr?(:empty) > empty?) | nil?
end

is_empty.call("").success? # => true
is_empty.call([]).success? # => true
is_empty.call({}).success? # => true
is_empty.call(nil).success? # => true

is_empty.call("string").success? # => false
is_empty.call(["array"]).success? # => false
is_empty.call({key: "value"}).success? # => false
```

### Exclusive or

Alias: `^`, `xor`

> Returns true only if one of its arguments are true, otherwise false.

Argument 1 | Argument 2 | Result
--- | --- | ---
true | true | false
true | false | true
false | true | true
false | false | false

``` ruby
is_zero = build do
  lt?(0) ^ gt?(0)
end

is_zero.call(1).success? # => false
is_zero.call(0).success? # => true
is_zero.call(-1).success? # => false
```

### And

Alias: `&`, `and`

> Returns true if both of its arguments are true.

Argument 1 | Argument 2 | Result
--- | --- | ---
true | true | true
true | false | false
false | true | false
false | false | false

``` ruby
is_middle_aged = build do
  gt?(30) & lt?(50)
end

is_child.call(20).success? # => false
is_child.call(40).success? # => true
is_child.call(60).success? # => true
```

### Attribute

> Run predicate on attribute specified by `name: :attribute`.

``` ruby
is_middle_aged = build do
  attr name: :age do
    gt?(30) & lt?(50)
  end
end

Person = Struct.new(:age)

is_middle_aged.call(Person.new(20)).success? # => false
is_middle_aged.call(Person.new(40)).success? # => true
is_middle_aged.call(Person.new(60)).success? # => false
```

### Each

> Validate each input value against a predicate. Passes when all values succeed.

``` ruby
is_only_odd = build do
  each { odd? }
end

is_only_odd.call([1, 3, 5]).success? # => true
is_only_odd.call([4, 6, 8]).success? # => false
```

### Set

Input: `Array<Predicate>`

> Applies input to an array of predicates. Returns true if all predicates are true.

``` ruby
is_natrual_and_odd = build do
  set { [int?, odd?, gt?(1)] }
end

is_natrual_and_odd.call('5').success? # => false
is_natrual_and_odd.call(5).success? # => true
is_natrual_and_odd.call(-1).success? # => false
```

### Negation

Input: `Predicate`

> Negates predicate.

``` ruby
is_present = build do
  negation(empty?)
end

is_present.call([1]).success? # => true
is_present.call([]).success? # => false
is_present.call("A").success? # => true
is_present.call("").success? # => false
```

### Key

Input: `Hash`, `Predicate`

> Takes a key path `name: path` and applies it to a predicate.

``` ruby
is_named = build do
  key name: [:user, :name] do
    str? & negation(empty?)
  end
end

is_named.call({ user: { name: "John" } }).success? # => true
is_named.call({ user: { name: nil } }).success? # => false
```

### Check

Input: `Hash`, `Predicate`

> Takes an array of key paths `keys: paths`. Applies each key path to its hash input and uses the result as arguments on its predicate. I.e `check = check keys: [[:a], [:b]] { pred }` invoking `check({a: "A", b: "B"})` yields `pred("A", "B")`.

``` ruby
is_speeding = build do
  check keys: [:speed, :limit] do
    lt?
  end
end

is_speeding.call({ speed: 100, limit: 50 }).success? # => true
is_speeding.call({ speed: 40, limit: 50 }).success? # => false
```
