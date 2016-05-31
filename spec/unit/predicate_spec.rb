require 'dry/logic/predicate'

RSpec.describe Dry::Logic::Predicate do
  describe '#call' do
    it 'returns result of the predicate function' do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }

      expect(is_empty.('').result).to be(true)

      expect(is_empty.('filled').result).to be(false)
    end

    it "raises argument error when incorrect number of args provided" do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      expect { is_empty.() }.to raise_error(ArgumentError)
      expect { min_age.curry(10).() }.to raise_error(ArgumentError)
      expect { min_age.(18) }.to raise_error(ArgumentError)
    end
  end

  describe '#curry' do
    it 'returns curried predicate' do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }

      min_age_18 = min_age.curry(18)

      expect(min_age_18.(18).result).to be(true)
      expect(min_age_18.(19).result).to be(true)
      expect(min_age_18.(17).result).to be(false)
    end
  end

  describe '#to_ast' do
    it 'returns correct predicate ast' do
      predicate = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }
      expect(predicate.curry(18).to_ast).to eql([:predicate, [:min_age, [[:age, 18], [:input, nil]]]])

      expect(predicate.curry(18).(21).to_ast).to eql([:predicate, [:min_age, [[:age, 18], [:input, 21]]]])
    end
  end
end
