---
title: Custom predicates
layout: gem-single
name: dry-logic
---

Define custom predicates using the `predicate` method. Use the build in builder to evaluate and define your predicate.

``` ruby
extend Dry::Logic::Builder

build do
  predicate :divisible_with? do |num, input|
    (input % num).zero?
  end
end
```

Then create your predicate

``` ruby
is_divisible_with_ten = build do
  divisible_with?(10)
end
```

Here, `10` represents the first argument `num` to `divisible_with?`.

``` ruby
# 10 & 5 is passed as {input} to your method
is_divisible_with_ten.call(10).success? # => true
is_divisible_with_ten.call(5).success? # => false
```
