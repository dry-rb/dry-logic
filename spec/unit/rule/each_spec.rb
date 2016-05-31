require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Each do
  include_context 'predicates'

  subject(:address_rule) do
    Dry::Logic::Rule::Each.new(is_string)
  end

  let(:is_string) { Dry::Logic::Rule::Value.new(str?) }

  describe '#call' do
    it 'applies its rules to all elements in the input' do
      expect(address_rule.(['Address'])).to be_success

      expect(address_rule.([nil, 'Address'])).to be_failure
      expect(address_rule.([:Address, 'Address'])).to be_failure
    end

    it 'returns result ast' do
      expect(address_rule.([1, nil]).to_ast).to eql([
        :result, [[1, nil], [
          :each, [
            [:el, [0, [:result, [1, [:val, [:predicate, [:str?, [[:input, 1]]]]]]]]],
            [:el, [1, [:result, [nil, [:val, [:predicate, [:str?, [[:input, nil]]]]]]]]]
          ]
        ]]
      ])
    end
  end
end

