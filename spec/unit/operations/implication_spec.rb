RSpec.describe Operations::Implication do
  subject(:operation) { Operations::Implication.new(left, right) }

  include_context 'predicates'

  let(:left) { Rule::Predicate.build(int?) }
  let(:right) { Rule::Predicate.build(gt?).curry(18) }

  describe '#call' do
    it 'calls left and right' do
      expect(operation.('19')).to be_success
      expect(operation.(19)).to be_success
      expect(operation.(18)).to be_failure
    end

    it 'yields a block on failure' do
      expect(operation.('19') { fail }).to be_success
      expect(operation.(19) { fail }).to be_success
      expect(operation.(18) { :else }).to be(:else)
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:implication, [[:predicate, [:int?, [[:input, Undefined]]]], [:predicate, [:gt?, [[:num, 18], [:input, Undefined]]]]]]
      )
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('int? THEN gt?(18)')
    end
  end
end
