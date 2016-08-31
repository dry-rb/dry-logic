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
end
