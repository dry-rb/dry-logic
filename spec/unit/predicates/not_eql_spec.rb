require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates, '#not_eql?' do
  let(:predicate_name) { :not_eql? }

  context 'when value is equal to the arg' do
    let(:arguments_list) do
      [['Foo', 'Foo']]
    end

    it_behaves_like 'a failing predicate'
  end

  context 'with value is not equal to the arg' do
    let(:arguments_list) do
      [['Bar', 'Foo']]
    end

    it_behaves_like 'a passing predicate'
  end
end
