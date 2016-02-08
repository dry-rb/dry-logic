require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Each do
  include_context 'predicates'

  subject(:address_rule) do
    Dry::Logic::Rule::Each.new(is_string)
  end

  let(:is_string) { Dry::Logic::Rule::Value.new(:name, str?) }

  describe '#call' do
    it 'applies its rules to all elements in the input' do
      expect(address_rule.(['Address'])).to be_success

      expect(address_rule.([nil, 'Address'])).to be_failure
      expect(address_rule.([:Address, 'Address'])).to be_failure
    end
  end
end
