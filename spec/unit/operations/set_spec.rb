RSpec.describe Operations::Set do
  subject(:operation) { Operations::Set.new(is_int, gt_18) }

  include_context 'predicates'

  let(:is_int) { Rule::Predicate.new(int?) }
  let(:gt_18) { Rule::Predicate.new(gt?, args: [18]) }

  describe '#call' do
    it 'applies all its rules to the input' do
      expect(operation.(19)).to be_success
      expect(operation.(17)).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:set, [[:predicate, [:int?, [[:input, Undefined]]]], [:predicate, [:gt?, [[:num, 18], [:input, Undefined]]]]]]
      )
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

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('set(int?, gt?(18))')
    end
  end
end
