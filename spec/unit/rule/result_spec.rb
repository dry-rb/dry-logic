require 'dry/logic/rule/result'

RSpec.describe Dry::Logic::Rule::Result do
  subject(:rule) { Dry::Logic::Rule::Result.new(:name, min_size?.curry(4)) }

  include_context 'predicates'

  let(:is_str) { Dry::Logic::Rule::Value.new(:name, str?) }
  let(:is_jane) { Dry::Logic::Rule::Result.new(:name, eql?.curry('jane')) }

  describe '#call' do
    it 'returns result of a predicate' do
      expect(rule.(name: is_str.('jane'))).to be_success
      expect(rule.(name: is_str.('jan'))).to be_failure
      expect(rule.(name: is_str.(nil))).to be_failure
    end

    it 'evaluates input for the ast' do
      expect(rule.(name: is_str.('jane')).to_ary).to eql([
        :input, [
          :name, nil, [[:res, [:name, [:predicate, [:min_size?, [4]]]]]]
        ]
      ])
    end
  end

  describe '#and' do
    it 'returns result of a conjunction' do
      expect(rule.and(is_jane).(name: is_str.('jane'))).to be_success
      expect(rule.and(is_jane).(name: is_str.('john'))).to be_failure
    end
  end
end
