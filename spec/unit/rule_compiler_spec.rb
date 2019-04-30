# frozen_string_literal: true

require 'dry/logic/rule_compiler'

RSpec.describe Dry::Logic::RuleCompiler, '#call' do
  subject(:compiler) { RuleCompiler.new(predicates) }

  let(:predicates) {
    { key?: predicate,
      attr?: predicate,
      filled?: predicate,
      gt?: predicate,
      one: predicate }
  }

  let(:predicate) { double(:predicate, name: :test?, arity: 2).as_null_object }

  let(:rule) { Rule::Predicate.build(predicate) }
  let(:key_op) { Operations::Key.new(rule, name: :email) }
  let(:attr_op) { Operations::Attr.new(rule, name: :email) }
  let(:check_op) { Operations::Check.new(rule, keys: [:email]) }
  let(:not_key_op) { Operations::Negation.new(key_op) }
  let(:and_op) { key_op.curry(:email) & rule }
  let(:or_op) { key_op.curry(:email) | rule }
  let(:xor_op) { key_op.curry(:email) ^ rule }
  let(:set_op) { Operations::Set.new(rule) }
  let(:each_op) { Operations::Each.new(rule) }

  it 'compiles key rules' do
    ast = [[:key, [:email, [:predicate, [:filled?, [[:input, Undefined]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([key_op])
  end

  it 'compiles attr rules' do
    ast = [[:attr, [:email, [:predicate, [:filled?, [[:input, Undefined]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([attr_op])
  end

  it 'compiles check rules' do
    ast = [[:check, [[:email], [:predicate, [:filled?, [[:input, Undefined]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([check_op])
  end

  it 'compiles attr rules' do
    ast = [[:attr, [:email, [:predicate, [:filled?, [[:input, Undefined]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([attr_op])
  end

  it 'compiles negated rules' do
    ast = [[:not, [:key, [:email, [:predicate, [:filled?, [[:input, Undefined]]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([not_key_op])
  end

  it 'compiles and rules' do
    ast = [
      [
        :and, [
          [:key, [:email, [:predicate, [:key?, [[:name, :email], [:input, Undefined]]]]]],
          [:predicate, [:filled?, [[:input, Undefined]]]]
        ]
      ]
    ]

    rules = compiler.(ast)

    expect(rules).to eql([and_op])
  end

  it 'compiles or rules' do
    ast = [
      [
        :or, [
          [:key, [:email, [:predicate, [:key?, [[:name, :email], [:input, Undefined]]]]]],
          [:predicate, [:filled?, [[:input, Undefined]]]]
        ]
      ]
    ]

    rules = compiler.(ast)

    expect(rules).to eql([or_op])
  end

  it 'compiles exclusive or rules' do
    ast = [
      [
        :xor, [
          [:key, [:email, [:predicate, [:key?, [[:name, :email], [:input, Undefined]]]]]],
          [:predicate, [:filled?, [[:input, Undefined]]]]
        ]
      ]
    ]

    rules = compiler.(ast)

    expect(rules).to eql([xor_op])
  end

  it 'compiles set rules' do
    ast = [[:set, [[:predicate, [:filled?, [[:input, nil]]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([set_op])
  end

  it 'compiles each rules' do
    ast = [[:each, [:predicate, [:filled?, [[:input, nil]]]]]]

    rules = compiler.(ast)

    expect(rules).to eql([each_op])
  end
end
