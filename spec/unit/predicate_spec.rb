require 'dry/logic/predicate'

RSpec.describe Dry::Logic::Predicate do
  describe '#call' do
    it 'returns result of the predicate function' do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }

      expect(is_empty.('')).to be(true)

      expect(is_empty.('filled')).to be(false)
    end

    it "raises argument error when incorrect number of args provided" do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      expect { is_empty.() }.to raise_error(ArgumentError)
      expect { min_age.curry(10).() }.to raise_error(ArgumentError)
      expect { min_age.curry(10, 12, 14) }.to raise_error(ArgumentError)
      expect { min_age.(18) }.to raise_error(ArgumentError)
      expect { min_age.(18,19,20,30) }.to raise_error(ArgumentError)
    end

    it "should ignore called args if already curried with all args" do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }
      min_age_10 = min_age.curry(10)
      expect(min_age_10.curry(11).(15,16)).to be(true)
    end

    it "predicates should work without any args" do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { true }

      expect(is_empty.()).to be(true)
    end
  end

  describe '#arity' do
    it 'returns arity of the predicate function' do
      is_equal = Dry::Logic::Predicate.new(:is_equal) { |left, right| left == right }

      expect(is_equal.arity).to eql(2)
    end
  end

  describe '#parameters' do
    it 'returns arity of the predicate function' do
      is_equal = Dry::Logic::Predicate.new(:is_equal) { |left, right| left == right }

      expect(is_equal.parameters).to eql([[:opt, :left], [:opt, :right]])
    end
  end

  describe '#arity' do
    it 'returns arity of the predicate function' do
      is_equal = Dry::Logic::Predicate.new(:is_equal) { |left, right| left == right }

      expect(is_equal.arity).to eql(2)
    end
  end

  describe '#parameters' do
    it 'returns arity of the predicate function' do
      is_equal = Dry::Logic::Predicate.new(:is_equal) { |left, right| left == right }

      expect(is_equal.parameters).to eql([[:opt, :left], [:opt, :right]])
    end
  end

  describe '#curry' do
    it 'returns curried predicate' do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      min_age_18 = min_age.curry(18)

      expect(min_age_18.args).to eql([18])

      expect(min_age_18.(18)).to be(true)
      expect(min_age_18.(19)).to be(true)
      expect(min_age_18.(17)).to be(false)
    end

    it 'can curry again & again' do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      min_age_18 = min_age.curry(18)

      expect(min_age_18.args).to eql([18])

      actual_age_19 = min_age_18.curry(19)

      expect(actual_age_19.()).to be(true)
      expect(actual_age_19.args).to eql([18,19])
    end
  end
end
