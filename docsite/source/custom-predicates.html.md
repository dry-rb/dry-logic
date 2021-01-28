---
title: Custom predicates
layout: gem-single
name: dry-logic
---

Define custom predicates using the `predicate` method.

``` ruby
build do
  predicate :divisible_with? do |num, input|
    (input % num).zero?
  end
end
```

The first value `num` to `predicate` is defined by `divisible_with?(num)` and the second argument `input` at a later point by the caller.

``` ruby
is_divisible_with_ten = build do
  divisible_with?(10)
end

is_divisible_with_ten.call(10).success? # => true
is_divisible_with_ten.call(5).success? # => false
```
