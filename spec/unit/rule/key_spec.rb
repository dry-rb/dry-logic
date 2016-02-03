require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Key do
  include_context 'predicates'

  subject(:rule) { Dry::Logic::Rule::Key.new(:user, key?.curry(:name)) }

  describe '#call' do
    it 'applies predicate to the value' do
      expect(rule.(user: { name: 'Jane' })).to be_success
      expect(rule.(user: {})).to be_failure
    end
  end

  describe '#and' do
    let(:other) { Dry::Logic::Rule::Key.new([:user, :name], str?) }

    it 'returns conjunction rule where value is passed to the right' do
      present_and_string = rule.and(other)

      expect(present_and_string.(user: { name: 'Jane' })).to be_success

      expect(present_and_string.(user: {})).to be_failure
      expect(present_and_string.(user: { name: 1 })).to be_failure
    end
  end
end
