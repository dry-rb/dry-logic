---
title: Builder
layout: gem-single
name: dry-logic
---

Use the build-in `Dry::Logic::Build` builder to run Dry Logic's predicates and operations.

``` ruby
require "dry/logic/build"

extend Dry::Logic::Build

is_zero = build do
  lt?(0) ^ gt?(0)
end

is_zero.call(0).success? # => true
is_zero.call(1).success? # => false
```
