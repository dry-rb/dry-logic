require 'dry/logic/rule/predicate'
require 'dry/logic/operations/check'

RSpec.describe Operations::Check do
  include_context 'predicates'

  describe '#call' do
    context 'with 1-level nesting' do
      subject(:operation) do
        Operations::Check.new(Rule::Predicate.new(eql?).curry(1), name: :compare, keys: [:num])
      end

      it 'applies predicate to args extracted from the input' do
        expect(operation.(num: 1)).to be_success

        expect(operation.(num: 2)).to be_failure

        expect(operation.(num: 1).to_ast).to eql(
          [:success, [:compare, [:predicate, [:eql?, [[:left, 1], [:right, 1]]]]]]
        )
      end
    end

    context 'with 2-levels nesting' do
      subject(:operation) do
        Operations::Check.new(Rule::Predicate.new(eql?), name: :compare, keys: [[:nums, :left], [:nums, :right]])
      end

      it 'applies predicate to args extracted from the input' do
        expect(operation.(nums: { left: 1, right: 1 })).to be_success
        expect(operation.(nums: { left: 1, right: 2 })).to be_failure
      end

      # check rules reverse the order of params to enable cases like `left.gt(right)` to work
      it 'curries args properly' do
        result = operation.(nums: { left: 1, right: 2 })

        expect(result.to_ast).to eql(
          [:failure, [:compare, [:predicate, [:eql?, [[:left, 2], [:right, 1]]]]]]
        )
      end
    end
  end
end
