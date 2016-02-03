require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Attr do
  include_context 'predicates'

  let(:model) { Struct.new(:name) }

  subject(:rule) { described_class.new(:name, str?) }

  describe '#call' do
    it 'applies predicate to the value' do
      expect(rule.(model.new('Jane'))).to be_success
      expect(rule.(model.new(nil))).to be_failure
    end
  end

  describe '#and' do
    let(:other) { Dry::Logic::Rule::Attr.new(:name, min_size?.curry(3)) }

    it 'returns conjunction rule where value is passed to the right' do
      present_and_string = rule.and(other)

      expect(present_and_string.(model.new('Jane'))).to be_success

      expect(present_and_string.(model.new('Ja'))).to be_failure
      expect(present_and_string.(model.new(1))).to be_failure
    end
  end
end
