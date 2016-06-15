require 'dry/logic'
require 'dry/logic/predicates'

include Dry::Logic

user_present = Rule::Key.new(Predicates[:filled?], name: :user)
has_min_age = Rule::Key.new(Predicates[:int?], name: [:user, :age]) & Rule::Key.new(Predicates[:gt?].curry(18), name: [:user, :age])

user_rule = user_present & has_min_age

puts user_rule.(user: { age: 19 }).inspect

puts user_rule.(user: { age: 18 }).inspect

puts user_rule.(user: { age: 'seventeen' }).inspect

puts user_rule.(user: { }).inspect

puts user_rule.({}).inspect
