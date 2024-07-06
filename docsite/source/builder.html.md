---
title: Builder
layout: gem-single
name: dry-logic
---

Use Dry Logic's builder to evaluate predicates and operations.

``` ruby
require "dry/logic/builder"

is_zero = Dry::Logic::Builder.call do
  lteq?(0) & gteq?(0)
end

is_zero.call(0).success? # => true
is_zero.call(1).success? # => false
```
