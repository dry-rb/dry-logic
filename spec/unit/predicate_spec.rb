require 'dry/logic/predicate'

RSpec.describe Predicate do
  describe '.new' do
    it 'can be initialized with empty args' do
      predicate = Predicate.new(:id) { |v| v.is_a?(Integer) }

      expect(predicate.to_ast).to eql([:predicate, [:id, [[:v, Predicate::Undefined]]]])
    end

    it 'can be initialized with args' do
      predicate = Predicate.new(:id, args: [1]) { |v| v.is_a?(Integer) }

      expect(predicate.to_ast).to eql([:predicate, [:id, [[:v, 1]]]])
    end

    it 'can be initialized with fn as the last arg' do
      predicate = Predicate.new(:id, args: [1], fn: -> v { v.is_a?(Integer) })

      expect(predicate.to_ast).to eql([:predicate, [:id, [[:v, 1]]]])
    end
  end

  describe '#bind' do
    it 'returns a predicate bound to a specific object' do
      fn = String.instance_method(:empty?)

      expect(Dry::Logic.Predicate(fn).bind("").()).to be(true)
      expect(Dry::Logic.Predicate(fn).bind("foo").()).to be(false)
    end
  end

  describe '#call' do
    it 'returns result of the predicate function' do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }

      expect(is_empty.('')).to be(true)

      expect(is_empty.('filled')).to be(false)
    end

    it "raises argument error when incorrect number of args provided" do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      expect { min_age.curry(10, 12, 14) }.to raise_error(ArgumentError)
      expect { min_age.(18, 19, 20, 30) }.to raise_error(ArgumentError)
      expect { min_age.curry(18).(19, 20) }.to raise_error(ArgumentError)
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
