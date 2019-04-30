# frozen_string_literal: true

RSpec.describe Result do
  include_context 'predicates'

  describe '#to_s' do
    shared_examples_for 'string representation' do
      it 'returns string representation' do
        expect(rule.(input).to_s).to eql(output)
      end
    end

    context 'with a predicate' do
      let(:rule) { Rule::Predicate.build(gt?, args: [18]) }
      let(:input) { 17 }
      let(:output) { 'gt?(18, 17)' }

      it_behaves_like 'string representation'
    end

    context 'with AND operation' do
      let(:rule) { Rule::Predicate.build(array?).and(Rule::Predicate.build(empty?)) }
      let(:input) { '' }
      let(:output) { 'array?("") AND empty?("")' }

      it_behaves_like 'string representation'
    end

    context 'with OR operation' do
      let(:rule) { Rule::Predicate.build(array?).or(Rule::Predicate.build(empty?)) }
      let(:input) { 123 }
      let(:output) { 'array?(123) OR empty?(123)' }

      it_behaves_like 'string representation'
    end

    context 'with XOR operation' do
      let(:rule) { Rule::Predicate.build(array?).xor(Rule::Predicate.build(empty?)) }
      let(:input) { [] }
      let(:output) { 'array?([]) XOR empty?([])' }

      it_behaves_like 'string representation'
    end

    context 'with THEN operation' do
      let(:rule) { Rule::Predicate.build(array?).then(Rule::Predicate.build(empty?)) }
      let(:input) { [1, 2, 3] }
      let(:output) { 'empty?([1, 2, 3])' }

      it_behaves_like 'string representation'
    end

    context 'with NOT operation' do
      let(:rule) { Operations::Negation.new(Rule::Predicate.build(array?)) }
      let(:input) { 'foo' }
      let(:output) { 'not(array?("foo"))' }

      it_behaves_like 'string representation'
    end
  end
end
