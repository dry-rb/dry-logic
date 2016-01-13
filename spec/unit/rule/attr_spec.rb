require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Attr do
  include_context 'predicates'

  let(:model) { Struct.new(:name) }

  subject(:rule) { described_class.new(:name, attr?) }

  describe '#call' do
    it 'applies predicate to the value' do
      expect(rule.(model.new(name: 'Jane'))).to be_success
      expect(rule.(nil)).to be_failure
    end
  end

  describe '#and' do
    let(:other) { Dry::Logic::Rule::Value.new(:name, str?) }

    it 'returns conjunction rule where value is passed to the right' do
      present_and_string = rule.and(other)

      expect(present_and_string.(model.new('Jane'))).to be_success

      expect(present_and_string.(nil)).to be_failure
      expect(present_and_string.(model.new(1))).to be_failure
    end
  end
end
