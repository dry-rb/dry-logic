RSpec.describe Operations::Negation do
  subject(:operation) { Operations::Negation.new(is_int) }

  include_context 'predicates'

  let(:is_int) { Rule::Predicate.new(int?) }

  describe '#call' do
    it 'negates its rule' do
      expect(operation.('19')).to be_success
      expect(operation.(17)).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:not, [:predicate, [:int?, [[:input, Undefined]]]]]
      )
    end

    it 'returns result ast' do
      expect(operation.(17).to_ast).to eql(
        [:not, [:predicate, [:int?, [[:input, 17]]]]]
      )
    end

    it 'returns result ast with an :id' do
      expect(operation.with(id: :age).(17).to_ast).to eql(
        [:failure, [:age, [:not, [:predicate, [:int?, [[:input, 17]]]]]]]
      )
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('not(int?)')
    end
  end
end
