shared_examples_for Dry::Logic::Rule do
  let(:predicate) { double(:predicate, arity: 2, name: predicate_name) }
  let(:rule_type) { described_class }
  let(:predicate_name) { :good? }

  describe '#arity' do
    it 'returns its predicate arity' do
      rule = rule_type.new(predicate)

      expect(rule.arity).to be(2)
    end
  end

  describe '#parameters' do
    it 'returns a list of args with their names' do
      rule = rule_type.new(-> foo, bar { true }, args: [312])

      expect(rule.parameters).to eql([[:req, :foo], [:req, :bar]])
    end
  end

  describe '#call' do
    it 'returns success for valid input' do
      rule = rule_type.new(predicate)

      expect(predicate).to receive(:[]).with(2).and_return(true)

      expect(rule.(2)).to be_success
    end

    it 'returns failure for invalid input' do
      rule = rule_type.new(predicate)

      expect(predicate).to receive(:[]).with(2).and_return(false)

      expect(rule.(2)).to be_failure
    end
  end

  describe '#[]' do
    it 'delegates to its predicate' do
      rule = rule_type.new(predicate)

      expect(predicate).to receive(:[]).with(2).and_return(true)
      expect(rule[2]).to be(true)
    end
  end

  describe '#curry' do
    it 'returns a curried rule' do
      rule = rule_type.new(predicate).curry(3)

      expect(predicate).to receive(:[]).with(3, 2).and_return(true)
      expect(rule.args).to eql([3])

      expect(rule.(2)).to be_success
    end

    it 'raises argument error when arity does not match' do
      expect(predicate).to receive(:arity).and_return(2)

      expect { rule_type.new(predicate).curry(3, 2, 1) }.to raise_error(
        ArgumentError, 'wrong number of arguments (3 for 2)'
      )
    end
  end
end
