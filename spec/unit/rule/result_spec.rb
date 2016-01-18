require 'dry/logic/rule/result'

RSpec.describe Dry::Logic::Rule::Result do
  subject(:rule) { Dry::Logic::Rule::Result.new(:email, min_size?.curry(4)) }

  include_context 'predicates'

  let(:is_str) { Dry::Logic::Rule::Value.new(:email, str?) }

  describe '#call' do
    it 'returns result of a predicate' do
      expect(rule.(is_str.('jane'))).to be_success
      expect(rule.(is_str.('jan'))).to be_failure
      expect(rule.(is_str.(nil))).to be_failure
    end
  end
end
