RSpec.describe Dry::Logic::Rule do
  it_behaves_like Dry::Logic::Rule

  describe '#bind' do
    subject(:rule) { Rule.new(predicate) }

    let(:predicate) { klass.instance_method(:test?) }
    let(:klass) { Class.new { def test?; true; end } }
    let(:object) { klass.new }

    it 'returns a new rule with its predicate bound to a specific object' do
      bound = rule.bind(object)

      expect(bound.options).to eql(rule.options)
      expect(bound.()).to be_success
    end
  end

  describe '#eval_args' do
    subject(:rule) { Rule.new(-> { true }, args: args) }

    let(:args) { [klass.instance_method(:num)] }
    let(:klass) { Class.new { def num; 7; end } }
    let(:object) { klass.new }

    it 'evaluates args in the context of the provided object' do
      expect(rule.eval_args(object).args).to eql([7])
    end
  end
end
