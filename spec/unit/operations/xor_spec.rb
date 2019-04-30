# frozen_string_literal: true

RSpec.describe Operations::Xor do
  subject(:operation) { Operations::Xor.new(left, right) }

  include_context 'predicates'

  let(:left) { Rule::Predicate.build(array?) }
  let(:right) { Rule::Predicate.build(empty?) }

  let(:other) do
    Rule::Predicate.build(str?)
  end

  describe '#call' do
    it 'calls left and right' do
      expect(operation.(nil)).to be_success
      expect(operation.('')).to be_success
      expect(operation.([])).to be_failure
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:xor, [[:predicate, [:array?, [[:input, Undefined]]]], [:predicate, [:empty?, [[:input, Undefined]]]]]]
      )
    end

    it 'returns result ast' do
      expect(operation.([]).to_ast).to eql(
        [:xor, [[:predicate, [:array?, [[:input, []]]]], [:predicate, [:empty?, [[:input, []]]]]]]
      )
    end

    it 'returns failure result ast' do
      expect(operation.with(id: :name).([]).to_ast).to eql(
        [:failure, [:name, [:xor, [[:predicate, [:array?, [[:input, []]]]], [:predicate, [:empty?, [[:input, []]]]]]]]]
      )
    end
  end

  describe '#and' do
    it 'creates conjunction with the other' do
      expect(operation.and(other).(nil)).to be_failure
      expect(operation.and(other).(19)).to be_failure
      expect(operation.and(other).('')).to be_success
    end
  end

  describe '#or' do
    it 'creates disjunction with the other' do
      expect(operation.or(other).([])).to be_failure
      expect(operation.or(other).('')).to be_success
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('array? XOR empty?')
    end
  end
end
