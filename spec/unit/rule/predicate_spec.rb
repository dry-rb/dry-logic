require 'dry/logic/rule/predicate'

RSpec.describe Dry::Logic::Rule::Predicate do
  subject(:rule) { Dry::Logic::Rule::Predicate.new(str?) }

  include_context 'predicates'

  it_behaves_like Dry::Logic::Rule

  describe '#name' do
    it 'returns predicate identifier' do
      expect(rule.name).to be(:str?)
    end
  end

  describe '#to_ast' do
    context 'without a result' do
      it 'returns rule ast' do
        expect(rule.to_ast).to eql([:predicate, [:str?, [[:input, Undefined]]]])
      end
    end

    context 'with a result' do
      it 'returns success ast' do
        expect(rule.('foo').to_ast).to eql([:success, [:predicate, [:str?, [[:input, 'foo']]]]])
      end

      it 'returns success ast' do
        expect(rule.(5).to_ast).to eql([:failure, [:predicate, [:str?, [[:input, 5]]]]])
      end
    end
  end
end
