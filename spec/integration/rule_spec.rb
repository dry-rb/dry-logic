require 'dry-logic'

RSpec.describe 'Rules' do
  specify 'defining an anonymous rule with an arbitrary predicate' do
    rule = Dry::Logic.Rule { |value| value.is_a?(Integer) }

    expect(rule.(1)).to be_success
    expect(rule[1]).to be(true)
  end

  specify 'defining a conjunction' do
    rule = Dry::Logic.Rule(&:even?) & Dry::Logic.Rule { |v| v > 4 }

    expect(rule.(3)).to be_failure
    expect(rule.(4)).to be_failure
    expect(rule.(5)).to be_failure
    expect(rule.(6)).to be_success
  end

  specify 'defining a disjunction' do
    rule = Dry::Logic.Rule { |v| v < 4 } | Dry::Logic.Rule { |v| v > 6 }

    expect(rule.(5)).to be_failure
    expect(rule.(3)).to be_success
    expect(rule.(7)).to be_success
  end

  specify 'defining an implication' do
    rule = Dry::Logic.Rule(&:empty?) > Dry::Logic.Rule { |v| v.is_a?(Array) }

    expect(rule.('foo')).to be_success
    expect(rule.([1, 2])).to be_success
    expect(rule.([])).to be_success
    expect(rule.('')).to be_failure
  end

  specify 'defining an exclusive disjunction' do
    rule = Dry::Logic.Rule(&:empty?) ^ Dry::Logic.Rule { |v| v.is_a?(Array) }

    expect(rule.('foo')).to be_failure
    expect(rule.([])).to be_failure
    expect(rule.([1, 2])).to be_success
    expect(rule.('')).to be_success
  end

  specify 'defining a rule with options' do
    rule = Dry::Logic::Rule(id: :empty?) { |value| value.empty? }

    expect(rule.('foo')).to be_failure
    expect(rule.('')).to be_success
    expect(rule.ast('foo')).to eql([:predicate, [:empty?, [[:value, 'foo']]]])
  end
end
