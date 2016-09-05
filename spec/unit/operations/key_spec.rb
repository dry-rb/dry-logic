RSpec.describe Operations::Key do
  subject(:operation) { Operations::Key.new(predicate, name: :user) }

  include_context 'predicates'

  let(:predicate) do
    Rule::Predicate.new(key?).curry(:age)
  end

  describe '#call' do
    context 'with a plain predicate' do
      it 'returns a success for valid input' do
        expect(operation.(user: { age: 18 })).to be_success
      end

      it 'returns a failure for invalid input' do
        result = operation.(user: {})

        expect(result).to be_failure

        expect(result.to_ast).to eql(
          [:failure, [:user, [:key, [:user,
            [:predicate, [:key?, [[:name, :age], [:input, {}]]]]
          ]]]]
        )
      end
    end

    context 'with a set rule as predicate' do
      subject(:operation) do
        Operations::Key.new(predicate, name: :address)
      end

      let(:predicate) do
        Operations::Set.new(Rule::Predicate.new(key?).curry(:city), Rule::Predicate.new(key?).curry(:zipcode))
      end

      it 'applies set rule to the value that passes' do
        result = operation.(address: { city: 'NYC', zipcode: '123' })

        expect(result).to be_success
      end

      it 'applies set rule to the value that fails' do
        result = operation.(address: { city: 'NYC' })

        expect(result).to be_failure

        expect(result.to_ast).to eql(
          [:failure, [:address, [:key, [:address, [:set, [
            [:predicate, [:key?, [[:name, :zipcode], [:input, { city: 'NYC' }]]]]
          ]]]]]]
        )
      end
    end

    context 'with an each rule as predicate' do
      subject(:operation) do
        Operations::Key.new(predicate, name: :nums)
      end

      let(:predicate) do
        Operations::Each.new(Rule::Predicate.new(str?))
      end

      it 'applies each rule to the value that passses' do
        result = operation.(nums: %w(1 2 3))

        expect(result).to be_success
      end

      it 'applies each rule to the value that fails' do
        failure = operation.(nums: [1, '3', 3])

        expect(failure).to be_failure

        expect(failure.to_ast).to eql(
          [:failure, [:nums, [:key, [:nums, [:set, [
            [:key, [0, [:predicate, [:str?, [[:input, 1]]]]]],
            [:key, [2, [:predicate, [:str?, [[:input, 3]]]]]]
          ]]]]]]
        )
      end
    end
  end

  describe '#to_ast' do
    it 'returns ast' do
      expect(operation.to_ast).to eql(
        [:key, [:user, [:predicate, [:key?, [[:name, :age], [:input, Undefined]]]]]]
      )
    end
  end

  describe '#and' do
    subject(:operation) do
      Operations::Key.new(Rule::Predicate.new(str?), name: [:user, :name])
    end

    let(:other) do
      Operations::Key.new(Rule::Predicate.new(filled?), name: [:user, :name])
    end

    it 'returns and rule where value is passed to the right' do
      present_and_string = operation.and(other)

      expect(present_and_string.(user: { name: 'Jane' })).to be_success

      expect(present_and_string.(user: {})).to be_failure
      expect(present_and_string.(user: { name: 1 })).to be_failure
    end
  end

  describe '#to_s' do
    it 'returns string representation' do
      expect(operation.to_s).to eql('key[user](key?(:age))')
    end
  end
end
