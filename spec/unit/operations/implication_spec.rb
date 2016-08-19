require 'dry/logic/rule/predicate'

RSpec.describe Operations::Implication do
  include_context 'predicates'

  subject(:rule) { Operations::Implication.new(left, right) }

  let(:left) { Rule::Predicate.new(int?) }
  let(:right) { Rule::Predicate.new(gt?).curry(18) }

  describe '#call' do
    it 'calls left and right' do
      expect(rule.('19')).to be_success
      expect(rule.(19)).to be_success
      expect(rule.(18)).to be_failure
    end
  end
end
