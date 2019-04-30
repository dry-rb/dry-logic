# frozen_string_literal: true

RSpec.describe Operations::Or do
  subject(:operation) { Operations::Or.new(left, right) }

  include_context 'predicates'

  let(:left) { Rule::Predicate.build(nil?) }
  let(:right) { Rule::Predicate.build(gt?).curry(18) }

  let(:other) do
    Rule::Predicate.build(int?) & Rule::Predicate.build(lt?).curry(14)
  end

  describe '#call' do
    it 'calls left and right' do
      expect(operation.(nil)).to be_success
      expect(operation.(19)).to be_success
      expect(operation.(18)).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:or, [
          [:predicate, [:nil?, [[:input, Undefined]]]],
          [:predicate, [:gt?, [[:num, 18], [:input, Undefined]]]]]
        ]
      )
    end

    it 'returns result ast' do
      expect(operation.(17).to_ast).to eql(
        [:or, [
          [:predicate, [:nil?, [[:input, 17]]]],
          [:predicate, [:gt?, [[:num, 18], [:input, 17]]]]]
        ]
      )
    end

    it 'returns failure result ast' do
      expect(operation.with(id: :age).(17).to_ast).to eql(
        [:failure, [:age, [:or, [
          [:predicate, [:nil?, [[:input, 17]]]],
          [:predicate, [:gt?, [[:num, 18], [:input, 17]]]]]
        ]]]
      )
    end
  end

  describe '#and' do
    it 'creates and with the other' do
      expect(operation.and(other).(nil)).to be_failure
      expect(operation.and(other).(19)).to be_failure
      expect(operation.and(other).(13)).to be_failure
      expect(operation.and(other).(14)).to be_failure
    end
  end

  describe '#or' do
    it 'creates or with the other' do
      expect(operation.or(other).(nil)).to be_success
      expect(operation.or(other).(19)).to be_success
      expect(operation.or(other).(13)).to be_success
      expect(operation.or(other).(14)).to be_failure
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('nil? OR gt?(18)')
    end
  end
end
