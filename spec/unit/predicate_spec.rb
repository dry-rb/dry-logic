require 'dry/logic/predicate'

RSpec.describe Dry::Logic::Predicate do
  describe '#call' do
    it 'returns result of the predicate function' do
      is_empty = Dry::Logic::Predicate.new(:is_empty) { |str| str.empty? }

      expect(is_empty.('')).to be(true)

      expect(is_empty.('filled')).to be(false)
    end
  end

  describe '#curry' do
    it 'returns curried predicate' do
      min_age = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }
      expect(min_age.args).to eql({age: nil, input: nil})

      min_age_18 = min_age.curry(18)
      expect(min_age_18.args).to eql({age: 18, input: nil})

      expect(min_age_18.(18)).to be(true)
      expect(min_age_18.args).to eql({age: 18, input: 18})
      expect(min_age_18.(19)).to be(true)
      expect(min_age_18.args).to eql({age: 18, input: 19})
      expect(min_age_18.(17)).to be(false)
      expect(min_age_18.args).to eql({age: 18, input: 17})
    end
  end

  describe '#to_ast' do
    it 'returns correct predicate ast' do
      predicate = Dry::Logic::Predicate.new(:min_age) { |age, input| input >= age }
      curried_predicate = predicate.curry(18)
      curried_predicate.(21)
      expect(curried_predicate.to_ast).to eql([:predicate, [:min_age, [[:age, 18], [:input, 21]]]])
    end
  end
end
