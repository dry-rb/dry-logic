RSpec.describe Operations::And do
  subject(:operation) { Operations::And.new(left, right) }

  include_context 'predicates'

  let(:left) { Rule::Predicate.new(int?) }
  let(:right) { Rule::Predicate.new(gt?).curry(18) }

  describe '#call' do
    it 'calls left and right' do
      expect(operation.(18)).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:and, [[:predicate, [:int?, [[:input, Undefined]]]], [:predicate, [:gt?, [[:num, 18], [:input, Undefined]]]]]]
      )
    end

    it 'returns result ast' do
      expect(operation.('18').to_ast).to eql(
        [:and, [[:predicate, [:int?, [[:input, '18']]]], [:hint, [:predicate, [:gt?, [[:num, 18], [:input, '18']]]]]]]
      )

      expect(operation.(18).to_ast).to eql(
        [:predicate, [:gt?, [[:num, 18], [:input, 18]]]]
      )
    end

    it 'returns failure result ast' do
      expect(operation.with(id: :age).('18').to_ast).to eql(
        [:failure, [:age, [:and, [[:predicate, [:int?, [[:input, '18']]]], [:hint, [:predicate, [:gt?, [[:num, 18], [:input, '18']]]]]]]]]
      )

      expect(operation.with(id: :age).(18).to_ast).to eql(
        [:failure, [:age, [:predicate, [:gt?, [[:num, 18], [:input, 18]]]]]]
      )
    end
  end

  describe '#and' do
    let(:other) { Rule::Predicate.new(lt?).curry(30) }

    it 'creates and with the other' do
      expect(operation.and(other).(31)).to be_failure
    end
  end

  describe '#or' do
    let(:other) { Rule::Predicate.new(lt?).curry(14) }

    it 'creates or with the other' do
      expect(operation.or(other).(13)).to be_success
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('int? AND gt?(18)')
    end
  end
end
