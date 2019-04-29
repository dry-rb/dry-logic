RSpec.describe Operations::Part do
  subject(:operation) { Operations::Part.new(is_odd, gt_18) }

  include_context 'predicates'

  let(:is_odd) { Rule::Predicate.new(odd?) }
  let(:gt_18) { Rule::Predicate.new(gt?, args: [18]) }

  describe '#call' do
    it 'applies at least one of its rules to the input' do
      expect(operation.(20)).to be_success
      expect(operation.(17)).to be_success
      expect(operation.(16)).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:part, [[:predicate, [:odd?, [[:input, Undefined]]]], [:predicate, [:gt?, [[:num, 18], [:input, Undefined]]]]]]
      )
    end

    it 'returns result ast' do
      expect(operation.(16).to_ast).to eql(
        [:part, [[:predicate, [:odd?, [[:input, 16]]]], [:predicate, [:gt?, [[:num, 18], [:input, 16]]]]]]
      )
    end

    it 'returns result ast with an :id' do
      expect(operation.with(id: :age).(16).to_ast).to eql(
        [:failure, [:age, [:part, [[:predicate, [:odd?, [[:input, 16]]]], [:predicate, [:gt?, [[:num, 18], [:input, 16]]]]]]]]
      )
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('part(odd?, gt?(18))')
    end
  end
end
