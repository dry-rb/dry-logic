# frozen_string_literal: true

require "dry/logic"
require "dry/logic/predicates"

# rubocop:disable Style/MixinUsage
include Dry::Logic
# rubocop:enable Style/MixinUsage

user_present = Rule::Predicate.build(Predicates[:key?]).curry(:user)

has_min_age = Operations::Key.new(Rule::Predicate.build(Predicates[:gt?]).curry(18),
                                  name: %i[user age])

user_rule = user_present & has_min_age

puts user_rule.(user: {age: 19}).success?

puts user_rule.(user: {age: 18}).success?
