# frozen_string_literal: true

require "dry/logic/rule_interpreter"

RSpec.describe Dry::Logic::RuleInterpreter, "#call" do
  subject(:interpreter) { described_class.new(predicates) }

  let(:predicates) {
    {key?: predicate,
     attr?: predicate,
     filled?: predicate,
     gt?: predicate,
     one: predicate}
  }

  let(:predicate) { double(:predicate, name: :test?, arity: 2).as_null_object }

  let(:rule) { Dry::Logic::Rule::Predicate.build(predicate) }
  let(:key_op) { Dry::Logic::Operations::Key.new(rule, name: :email) }
  let(:attr_op) { Dry::Logic::Operations::Attr.new(rule, name: :email) }
  let(:check_op) { Dry::Logic::Operations::Check.new(rule, keys: [:email]) }
  let(:not_key_op) { Dry::Logic::Operations::Negation.new(key_op) }
  let(:and_op) { key_op.curry(:email) & rule }
  let(:or_op) { key_op.curry(:email) | rule }
  let(:xor_op) { key_op.curry(:email) ^ rule }
  let(:set_op) { Dry::Logic::Operations::Set.new(rule) }
  let(:each_op) { Dry::Logic::Operations::Each.new(rule) }

  it "interpretes key rules" do
    rules = interpreter.compile("key[email](filled?)")

    expect(rules).to eql([key_op])
  end

  it "interpretes attr rules" do
    rules = interpreter.compile("attr[email](filled?)")

    expect(rules).to eql([attr_op])
  end

  it "interpretes check rules" do
    rules = interpreter.compile("check[email](filled?)")

    expect(rules).to eql([check_op])
  end

  it "interpretes negated rules" do
    rules = interpreter.compile("not(key[email](filled?))")

    expect(rules).to eql([not_key_op])
  end

  it "interpretes and rules" do
    rules = interpreter.compile("key[email](key?(:email)) AND filled?")

    expect(rules).to eql([and_op])
  end

  it "interpretes or rules" do
    rules = interpreter.compile("key[email](key?(:email)) OR filled?")

    expect(rules).to eql([or_op])
  end

  it "interpretes exclusive or rules" do
    rules = interpreter.compile("key[email](key?(:email)) XOR filled?")
    expect(rules).to eql([xor_op])
  end

  it "interpretes set rules" do
    rules = interpreter.compile("set(filled?)")

    expect(rules).to eql([set_op])
  end

  it "interpretes each rules" do
    rules = interpreter.compile("each(filled?)")

    expect(rules).to eql([each_op])
  end
end

