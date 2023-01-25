---
title: Operations
layout: gem-single
name: dry-logic
---

Operations work on one or more predicates (see predicates) and can be invoked in conjunction with other operations. Use `Dry::Logic::Builder` to evaluate operations & predicates.

``` ruby
extend Dry::Logic::Builder

is_zero = build { eql?(0) }
is_zero.call(10).success?
```

### Or (`|`, `or`)

> Returns true if one of its arguments is true. Similar to Ruby's `||` operator

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

### Implication (`>`, `then`, `implication`)

> Similar to Ruby's `if then` expression

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

### Exclusive or (`^`, `xor`)

> Returns true if at most one of its arguments are valid; otherwise, false

Argument 1 | Argument 2 | Result
--- | --- | ---
true | true | false
true | false | true
false | true | true
false | false | false

``` ruby
is_not_zero = build do
  lt?(0) ^ gt?(0)
end

is_not_zero.call(1).success? # => true
is_not_zero.call(0).success? # => false
is_not_zero.call(-1).success? # => true
```

### And (`&`, `and`)

> Returns true if both of its arguments are true. Similar to Ruby's `&&` operator

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

### Attribute (`attr`)

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

### Each (`each`)

> True when any of the inputs is true when applied to the predicate. Similar to `Array#any?`

``` ruby
is_only_odd = build do
  each { odd? }
end

is_only_odd.call([1, 3, 5]).success? # => true
is_only_odd.call([4, 6, 8]).success? # => false
```

### Set (`set`)

> Applies input to an array of predicates. Returns true if all predicates yield true. Similar to `Array#all?`

``` ruby
is_natural_and_odd = build do
  set(int?, odd?, gt?(1))
end

is_natural_and_odd.call('5').success? # => false
is_natural_and_odd.call(5).success? # => true
is_natural_and_odd.call(-1).success? # => false
```

### Negation (`negation`, `not`)

> Returns true when predicate returns false. Similar to Ruby's `!` operator

``` ruby
is_present = build do
  negation(empty?)
end

is_present.call([1]).success? # => true
is_present.call([]).success? # => false
is_present.call("A").success? # => true
is_present.call("").success? # => false
```

### Key (`key`)

``` ruby
is_named = build do
  key name: [:user, :name] do
    str? & negation(empty?)
  end
end

is_named.call({ user: { name: "John" } }).success? # => true
is_named.call({ user: { name: nil } }).success? # => false
```

### Check (`check`)

``` ruby
is_allowed_to_drive = build do
  check keys: [:age] do
    gt?(18)
  end
end

is_allowed_to_drive.call({ age: 30 }).success? # => true
is_allowed_to_drive.call({ age: 10 }).success? # => false
```

Or when the predicate allows for more than one argument.

``` ruby
is_speeding = build do
  check keys: [:speed, :limit] do
    lt?
  end
end

is_speeding.call({ speed: 100, limit: 50 }).success? # => true
is_speeding.call({ speed: 40, limit: 50 }).success? # => false
```

Which is the same as this

``` ruby
input[:limit].lt?(*input.values_at(:speed))
```
