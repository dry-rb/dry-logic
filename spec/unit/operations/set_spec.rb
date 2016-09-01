require 'dry/logic/rule/predicate'
require 'dry/logic/operations/set'

RSpec.describe Operations::Set do
  include_context 'predicates'

  subject(:operation) do
    Operations::Set.new(is_int, gt_18)
  end

  let(:is_int) { Rule::Predicate.new(int?) }
  let(:gt_18) { Rule::Predicate.new(gt?, args: [18]) }

  describe '#call' do
    it 'applies all its rules to the input' do
      expect(operation.(19)).to be_success
      expect(operation.(17)).to be_failure
    end

    it 'returns result ast' do
      expect(operation.(17).to_ast).to eql(
        [:set, [[:predicate, [:gt?, [[:num, 18], [:input, 17]]]]]]
      )
    end

    it 'returns result ast with an :id' do
      expect(operation.with(id: :age).(17).to_ast).to eql(
        [:failure, [:age, [:set, [[:predicate, [:gt?, [[:num, 18], [:input, 17]]]]]]]]
      )
    end
  end
end
