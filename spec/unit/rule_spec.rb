RSpec.describe Dry::Logic::Rule do
  include_context 'predicates'

  describe '#inspect' do
    it 'with a value rule' do
      expect(Rule::Value.new(str?).inspect).to eql("#<Dry::Logic::Rule[str?]>")
    end

    it 'with a composite rule' do
      expect(Rule::Value.new(key?.curry(:name)).and(Rule::Value.new(str?)).inspect).to eql(
        '#<Dry::Logic::Rule[key?(:name) AND str?]>'
      )
    end
  end
end
