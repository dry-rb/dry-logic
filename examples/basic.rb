require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Predicate.new(Predicates[:key?]).curry(:user)

has_min_age = Operations::Key.new(Rule::Predicate.new(Predicates[:gt?]).curry(18), name: [:user, :age])

user_rule = user_present & has_min_age

puts user_rule.(user: { age: 19 }).success?

puts user_rule.(user: { age: 18 }).success?
