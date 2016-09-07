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

  describe '#bind' do
    context 'with an unbound method' do
      let(:predicate) { klass.instance_method(:test?) }
      let(:klass) { Class.new { def test?; true; end } }
      let(:object) { klass.new }

      it 'returns a new rule with its predicate bound to a specific object' do
        bound = rule.bind(object)

        expect(bound.options).to eql(rule.options)
        expect(bound.()).to be_success
      end
    end

    context 'with an arbitrary block' do
      let(:predicate) { -> value { value == expected } }
      let(:object) { Class.new { def expected; 'test'; end }.new }

      it 'returns a new with its predicate executed in the context of the provided object' do
        bound = rule.bind(object)

        expect(bound.parameters).to eql([[:req, :value]])

        expect(bound.('test')).to be_success
        expect(bound.('oops')).to be_failure
      end
    end
  end

  describe '#eval_args' do
    let(:options) { { args: [klass.instance_method(:num)] } }
    let(:klass) { Class.new { def num; 7; end } }
    let(:object) { klass.new }

    it 'evaluates args in the context of the provided object' do
      expect(rule.eval_args(object).args).to eql([7])
    end
  end
end
