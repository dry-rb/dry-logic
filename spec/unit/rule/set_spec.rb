require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Set do
  include_context 'predicates'

  subject(:rule) do
    Dry::Logic::Rule::Set.new([is_string, min_size.curry(6)])
  end

  let(:is_string) { Dry::Logic::Rule::Value.new(:name, str?) }
  let(:min_size) { Dry::Logic::Rule::Value.new(:name, min_size?) }

  describe '#call' do
    it 'applies its rules to the input' do
      expect(rule.('Address')).to be_success
      expect(rule.('Addr')).to be_failure
    end
  end

  describe '#to_ary' do
    it 'returns an array representation' do
      expect(rule).to match_array([
        :set, [
          [:val, [:name, [:predicate, [:str?, []]]]],
          [:val, [:name, [:predicate, [:min_size?, [6]]]]]
        ]
      ])
    end
  end
end
