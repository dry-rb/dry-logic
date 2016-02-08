require 'dry/logic/rule'

RSpec.describe Rule::Key do
  include_context 'predicates'

  subject(:rule) do
    Rule::Key.new(:user, predicate)
  end

  let(:predicate) do
    key?.curry(:name)
  end

  let(:other) do
    Rule::Key.new([:user, :name], str?)
  end

  describe '#call' do
    context 'with a predicate' do
      it 'applies predicate to the value' do
        expect(rule.(user: { name: 'Jane' })).to be_success
        expect(rule.(user: {})).to be_failure
      end
    end

    context 'with an each rule' do
      subject(:rule) do
        Rule::Key.new(:nums, predicate)
      end

      let(:predicate) { Rule::Each.new(Rule::Value.new(:num, str?)) }

      it 'applies each rule to the value' do
        success = rule.(nums: %w(1 2 3))

        expect(success).to be_success

        expect(success.to_ary).to eql(
          [:input, [:nums, { nums: %w(1 2 3) }, []]]
        )

        failure = rule.(nums: [1, '3', 3])

        expect(failure).to be_failure

        expect(failure.to_ary).to eql(
          [
            :input, [
              :nums, { nums: [1, '3', 3] }, [
                [:el, [0, [
                  :input, [:num, 1, [[:val, [:num, [:predicate, [:str?, []]]]]]]
                ]]],
                [:el, [2, [
                  :input, [:num, 3, [[:val, [:num, [:predicate, [:str?, []]]]]]]
                ]]]
              ]
            ]
          ]
        )
      end
    end
  end

  describe '#and' do
    it 'returns conjunction rule where value is passed to the right' do
      present_and_string = rule.and(other)

      expect(present_and_string.(user: { name: 'Jane' })).to be_success

      expect(present_and_string.(user: {})).to be_failure
      expect(present_and_string.(user: { name: 1 })).to be_failure
    end
  end
end
