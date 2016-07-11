RSpec.describe Dry::Logic::Rule do
  include_context 'predicates'

  describe '#inspect' do
    it 'with a value rule' do
      expect(Rule::Value.new(str?).inspect).to eql("#<Dry::Logic::Rule[str?]>")
    end

    it 'with a conjunction' do
      expect(Rule::Value.new(key?.curry(:name)).and(Rule::Value.new(str?)).inspect).to eql(
        '#<Dry::Logic::Rule[(key?(:name) AND str?)]>'
      )
    end

    it 'with a disjunction' do
      expect(Rule::Value.new(str?).or(Rule::Value.new(int?)).inspect).to eql(
        '#<Dry::Logic::Rule[(str? OR int?)]>'
      )
    end

    it 'with an implication' do
      expect(Rule::Value.new(str?).then(Rule::Value.new(size?.curry(8))).inspect).to eql(
        '#<Dry::Logic::Rule[(str? THEN size?(8))]>'
      )
    end

    it 'with an exclusive disjunction' do
      expect(Rule::Value.new(size?.curry(8)).xor(Rule::Value.new(int?)).inspect).to eql(
        '#<Dry::Logic::Rule[(size?(8) XOR int?)]>'
      )
    end
  end
end
