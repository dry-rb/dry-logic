RSpec.describe Operations::Check do
  include_context 'predicates'

  describe '#call' do
    context 'with 1-level nesting' do
      subject(:operation) do
        Operations::Check.new(Rule::Predicate.new(eql?).curry(1), id: :compare, keys: [:num])
      end

      it 'applies predicate to args extracted from the input' do
        expect(operation.(num: 1)).to be_success
        expect(operation.(num: 2)).to be_failure
      end
    end

    context 'with 2-levels nesting' do
      subject(:operation) do
        Operations::Check.new(Rule::Predicate.new(eql?), id: :compare, keys: [[:nums, :left], [:nums, :right]])
      end

      it 'applies predicate to args extracted from the input' do
        expect(operation.(nums: { left: 1, right: 1 })).to be_success
        expect(operation.(nums: { left: 1, right: 2 })).to be_failure
      end

      # check rules reverse the order of params to enable cases like `left.gt(right)` to work
      it 'curries args properly' do
        result = operation.(nums: { left: 1, right: 2 })

        expect(result.to_ast).to eql(
          [:failure, [:compare, [:check, [
            :compare, [[:nums, :left], [:nums, :right]], [:predicate, [:eql?, [[:left, 2], [:right, 1]]]]]
          ]]]
        )
      end
    end
  end

  describe '#to_ast' do
    subject(:operation) do
      Operations::Check.new(
        Rule::Predicate.new(str?), id: :verify_email, keys: [:email]
      )
    end

    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:check, [:verify_email, [:email], [:predicate, [:str?, [[:input, Undefined]]]]]]
      )
    end
  end
end
