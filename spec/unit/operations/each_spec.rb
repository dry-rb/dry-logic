require 'dry/logic/rule/predicate'
require 'dry/logic/operations/each'

RSpec.describe Operations::Each do
  include_context 'predicates'

  subject(:operation) do
    Operations::Each.new(is_string)
  end

  let(:is_string) { Rule::Predicate.new(str?) }

  describe '#call' do
    it 'applies its rules to all elements in the input' do
      expect(operation.(['Address'])).to be_success

      expect(operation.([nil, 'Address'])).to be_failure
      expect(operation.([:Address, 'Address'])).to be_failure
    end

    it 'returns result ast' do
      expect(operation.([nil, nil]).to_ast).to eql(
        [:each, [
          [:path, [0, [:predicate, [:str?, [[:input, nil]]]]]],
          [:path, [1, [:predicate, [:str?, [[:input, nil]]]]]]
        ]]
      )
    end
  end
end
