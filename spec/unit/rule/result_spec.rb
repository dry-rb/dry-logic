require 'dry/logic/rule/result'

RSpec.describe Dry::Logic::Rule::Result do
  subject(:rule) { Dry::Logic::Rule::Result.new(:name, min_size?.curry(4)) }

  include_context 'predicates'

  let(:is_str) { Dry::Logic::Rule::Value.new(:name, str?) }

  describe '#call' do
    it 'returns result of a predicate' do
      expect(rule.(name: is_str.('jane'))).to be_success
      expect(rule.(name: is_str.('jan'))).to be_failure
      expect(rule.(name: is_str.(nil))).to be_failure
    end
  end
end
