require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Key.new(:user, Predicates[:key?])
has_min_age = Rule::Key.new(:age, Predicates[:key?]) & Rule::Value.new(:age, Predicates[:gt?].curry(18))

user_rule = user_present & has_min_age

puts user_rule.(user: { age: 19 }).inspect

puts user_rule.(user: { age: 18 }).inspect
