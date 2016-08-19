require 'dry/logic/rule/predicate'
require 'dry/logic/operations/exclusive_disjunction'

RSpec.describe Operations::ExclusiveDisjunction do
  include_context 'predicates'

  subject(:operation) do
    Operations::ExclusiveDisjunction.new(left, right)
  end

  let(:left) { Rule::Predicate.new(int?) }
  let(:right) { Rule::Predicate.new(gt?).curry(18) }

  describe '#call' do
    it 'calls left and right' do
      expect(operation.(12)).to be_success
      expect(operation.(18)).to be_success
      expect(operation.(21)).to be_failure
    end
  end
end
