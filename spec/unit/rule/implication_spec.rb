RSpec.describe Rule::Composite::Implication do
  include_context 'predicates'

  subject(:rule) { Rule::Composite::Implication.new(left, right) }

  let(:left) { Rule::Value.new(:age, int?) }
  let(:right) { Rule::Value.new(:age, gt?.curry(18)) }

  describe '#call' do
    it 'calls left and right' do
      expect(rule.('19')).to be_success
      expect(rule.(19)).to be_success
      expect(rule.(18)).to be_failure
    end
  end
end
