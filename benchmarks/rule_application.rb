# frozen_string_literal: true

require_relative 'setup'

unless Dry::Logic::Rule.respond_to?(:build)
  Dry::Logic::Rule.singleton_class.alias_method(:build, :new)
end

predicates = Dry::Logic::Predicates

type_check = Dry::Logic::Rule.build(predicates[:type?]).curry(Integer)
int_check = Dry::Logic::Rule.build(predicates[:int?])
key_check = Dry::Logic::Rule.build(predicates[:key?]).curry(:user)
with_user = { user: {} }
without_user = {}

comparison = Dry::Logic::Rule.build(predicates[:gteq?]).curry(18)

Benchmark.ips do |x|
  x.report("type check - success") { type_check.(0) }
  x.report("type check - failure") { type_check.('0') }
  x.report("int check - success") { int_check.(0) }
  x.report("int check - failure") { int_check.('0') }
  x.report("key check - success") { key_check.(with_user) }
  x.report("key check - failure") { key_check.(without_user) }
  x.report("comparison - success") { comparison.(20) }
  x.report("comparison - failure") { comparison.(17) }

  x.compare!
end
