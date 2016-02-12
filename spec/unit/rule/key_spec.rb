require 'dry/logic/rule'

RSpec.describe Rule::Key do
  include_context 'predicates'

  subject(:rule) do
    Rule::Key.new(predicate, name: :user)
  end

  let(:predicate) do
    key?.curry(:name)
  end

  describe '#call' do
    context 'with a plain predicate' do
      it 'applies predicate to the value' do
        expect(rule.(user: { name: 'Jane' })).to be_success
        expect(rule.(user: {})).to be_failure
      end
    end

    context 'with a set rule as predicate' do
      subject(:rule) do
        Rule::Key.new(predicate, name: :address)
      end

      let(:predicate) do
        Rule::Set.new(
          [Rule::Value.new(key?.curry(:city)), Rule::Value.new(key?.curry(:zipcode))]
        )
      end

      it 'applies set rule to the value that passes' do
        result = rule.(address: { city: 'NYC', zipcode: '123' })

        expect(result).to be_success
      end

      it 'applies set rule to the value that fails' do
        result = rule.(address: { city: 'NYC' })

        expect(result).to be_failure

        expect(result.to_ary).to eql([
          :input, [
            :address,
              [:result, [
                { city: "NYC" },
                [:set, [[:result, [{ city: 'NYC' }, [:val, [:predicate, [:key?, [:zipcode]]]]]]]]
              ]]
            ]
        ])
      end
    end

    context 'with an each rule as predicate' do
      subject(:rule) do
        Rule::Key.new(predicate, name: :nums)
      end

      let(:predicate) do
        Rule::Each.new(Rule::Value.new(str?))
      end

      it 'applies each rule to the value that passses' do
        result = rule.(nums: %w(1 2 3))

        expect(result).to be_success

        expect(result.to_ary).to eql([
          :input, [:nums, [:result, [%w(1 2 3), [:each, []]]]]
        ])
      end

      it 'applies each rule to the value that fails' do
        failure = rule.(nums: [1, '3', 3])

        expect(failure).to be_failure

        expect(failure.to_ary).to eql([
          :input, [
            :nums, [
              :result, [
                [1, '3', 3],
                [:each, [
                  [:el, [0, [:result, [1, [:val, [:predicate, [:str?, []]]]]]]],
                  [:el, [2, [:result, [3, [:val, [:predicate, [:str?, []]]]]]]]
                ]]
              ]
            ]
          ]
        ])
      end
    end
  end

  describe '#and' do
    let(:other) do
      Rule::Key.new(str?, name: [:user, :name])
    end

    it 'returns conjunction rule where value is passed to the right' do
      present_and_string = rule.and(other)

      expect(present_and_string.(user: { name: 'Jane' })).to be_success

      expect(present_and_string.(user: {})).to be_failure
      expect(present_and_string.(user: { name: 1 })).to be_failure
    end
  end
end
