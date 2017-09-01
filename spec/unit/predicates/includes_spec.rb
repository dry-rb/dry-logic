require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates, '#is?' do
  let(:predicate_name) { :is? }
  let(:one) { Object.new }
  let(:two) { Object.new }

  context 'when value is equal to the arg' do
    let(:arguments_list) do
      [[one, one], [:one, :one]]
    end

    it_behaves_like 'a passing predicate'
  end

  context 'with value is not equal to the arg' do
    let(:arguments_list) do
      # Strings are not equal. Yet
      [[one, two], ['one', 'one']]
    end

    it_behaves_like 'a failing predicate'
  end
end
