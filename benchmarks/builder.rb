# frozen_string_literal: true

require "benchmark/ips"
require "dry/logic"
require "dry/logic/builder"

def regular
  user_present = Dry::Logic::Rule::Predicate.new(Dry::Logic::Predicates[:key?]).curry(:user)
  min_age = Dry::Logic::Rule::Predicate.new(Dry::Logic::Predicates[:gt?]).curry(18)
  has_min_age = Dry::Logic::Operations::Key.new(min_age, name: %i[user age])
  user_present & has_min_age
end

def builder
  Dry::Logic::Builder.call do
    key?(:user) & key(name: %i[user age]) { gt?(18) }
  end
end

Benchmark.ips do |x|
  x.report("builder") do
    builder.(user: {age: 19})
    builder.(user: {age: 18})
  end

  x.report("regular") do
    regular.(user: {age: 18})
    regular.(user: {age: 19})
  end

  x.compare!
end
