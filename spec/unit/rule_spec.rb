RSpec.describe Dry::Logic::Rule do
  subject(:rule) { Rule.new(predicate, options) }

  let(:predicate) { -> { true } }
  let(:options) { {} }

  it_behaves_like Dry::Logic::Rule

  describe '.new' do
    it 'accepts an :id' do
      expect(Rule.new(predicate, id: :check_num).id).to be(:check_num)
    end
  end

  describe 'with a function returning truthy value' do
    it 'is successful for valid input' do
      expect(Rule.new(-> val { val }).('true')).to be_success
    end

    it 'is not successful for invalid input' do
      expect(Rule.new(-> val { val }).(nil)).to be_failure
    end
  end

  describe '#ast' do
    it 'returns predicate node with :id' do
      expect(Rule.new(-> value { true }).with(id: :email?).ast('oops')).to eql(
        [:predicate, [:email?, [[:value, 'oops']]]]
      )
    end
  end

  describe '#type' do
    it 'returns rule type' do
      expect(rule.type).to be(:rule)
    end
  end

  describe '#bind' do
    let(:bound) { rule.with(id: :bound).bind(object) }

    context 'with an unbound method' do
      let(:predicate) { klass.instance_method(:test?) }
      let(:klass) { Class.new { def test?; true; end } }
      let(:object) { klass.new }

      it 'returns a new rule with its predicate bound to a specific object' do
        expect(bound.()).to be_success
      end

      it 'carries id' do
        expect(bound.id).to be(:bound)
      end
    end

    context 'with an arbitrary block' do
      let(:predicate) { -> value { value == expected } }
      let(:object) { Class.new { def expected; 'test'; end }.new }

      it 'returns a new with its predicate executed in the context of the provided object' do
        expect(bound.('test')).to be_success
        expect(bound.('oops')).to be_failure
      end

      it 'carries id' do
        expect(bound.id).to be(:bound)
      end

      it 'stores arity' do
        expect(bound.options[:arity]).to be(rule.arity)
      end

      it 'stores parameters' do
        expect(bound.options[:parameters]).to eql(rule.parameters)
      end
    end
  end

  describe '#eval_args' do
    let(:options) { { args: [1, klass.instance_method(:num), :foo] } }
    let(:klass) { Class.new { def num; 7; end } }
    let(:object) { klass.new }

    it 'evaluates args in the context of the provided object' do
      expect(rule.eval_args(object).args).to eql([1, 7, :foo])
    end
  end
end
