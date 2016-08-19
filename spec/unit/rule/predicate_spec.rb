require 'dry/logic/rule/predicate'

RSpec.describe Dry::Logic::Rule::Predicate do
  include_context 'predicates'

  it_behaves_like Dry::Logic::Rule

  describe '#name' do
    it 'returns predicate identifier' do
      rule = Dry::Logic::Rule::Predicate.new(str?)

      expect(rule.name).to be(:str?)
    end
  end
end
