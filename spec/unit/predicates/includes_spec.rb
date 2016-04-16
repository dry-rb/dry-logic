require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#includes?' do
    let(:predicate_name) { :includes? }

    context 'when input includes value' do
      let(:arguments_list) do
        [
          ['Jill', ['Jill', 'John']],
          ['John', ['Jill', 'John']],
          [1, 1..2],
          [2, 1..2],
          [nil, [nil, false]],
          [false, [nil, false]]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with input excludes value' do
      let(:arguments_list) do
        [
          ['Jack', ['Jill', 'John']],
          [0, 1..2],
          [3, 1..2],
          [true, [nil, false]]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
