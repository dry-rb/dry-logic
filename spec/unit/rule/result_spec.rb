require 'dry/logic/rule/result'

RSpec.describe Dry::Logic::Rule::Result do
  subject(:rule) { Dry::Logic::Rule::Result.new(:name, min_size?.curry(4)) }

  include_context 'predicates'

  let(:is_str) { Dry::Logic::Rule::Value.new(:name, str?) }
  let(:is_jane) { Dry::Logic::Rule::Result.new(:name, eql?.curry('jane')) }
  let(:is_john) { Dry::Logic::Rule::Result.new(:name, eql?.curry('john')) }

  describe '#call' do
    it 'returns result of a predicate' do
      expect(rule.(name: is_str.('jane'))).to be_success
      expect(rule.(name: is_str.('jan'))).to be_failure
      expect(rule.(name: is_str.(nil))).to be_failure
    end

    it 'evaluates successful input for the ast' do
      expect(rule.(name: is_str.('jane')).to_ary).to eql([
        :input, [
          :name, nil, [[:res, [:name, [:predicate, [:min_size?, [4]]]]]]
        ]
      ])
    end

    it 'evaluates failed input for the ast' do
      expect(rule.(name: is_str.(:john)).to_ary).to eql([
        :input, [
          :name, :john, [[:val, [:name, [:predicate, [:str?, []]]]]]
        ]
      ])
    end
  end

  describe '#and' do
    let(:conjunction) { rule.and(is_jane) }

    it 'returns result of a conjunction' do
      expect(conjunction.(name: is_str.('jane'))).to be_success
      expect(conjunction.(name: is_str.('john'))).to be_failure
    end

    it 'evaluates input for the ast' do
      expect(conjunction.(name: is_str.('john')).to_ary).to eql([
        :input, [
          :name, nil, [[:res, [:name, [:predicate, [:eql?, ["jane"]]]]]]
        ]
      ])
    end
  end

  describe '#xor' do
    let(:xor) { rule.xor(is_john) }

    it 'returns result of an exclusive disjunction' do
      expect(xor.(name: is_str.('jane'))).to be_success
      expect(xor.(name: is_str.('john'))).to be_failure
    end

    it 'evaluates input for the ast' do
      result = xor.(name: is_str.('john'))

      expect(result.to_ary).to eql([
        :input, [
          :name, nil, [[:res, [:name, [:predicate, [:min_size?, [4]]]]]]
        ]
      ])
    end
  end

  describe '#then' do
    let(:implication) { rule.then(is_jane) }

    it 'returns result of an exclusive disjunction' do
      expect(implication.(name: is_str.('jane'))).to be_success
      expect(implication.(name: is_str.(nil))).to be_success
      expect(implication.(name: is_str.('john'))).to be_failure
    end

    it 'evaluates input for the ast' do
      result = implication.(name: is_str.('john'))

      expect(result.to_ary).to eql([
        :input, [
          :name, nil, [[:res, [:name, [:predicate, [:eql?, ['jane']]]]]]
        ]
      ])
    end
  end
end
