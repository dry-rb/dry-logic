require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#odd?' do
    let(:predicate_name) { :odd? }

    context 'when value is an odd int' do
      let(:arguments_list) do
        [
          [13],
          [1],
          [1111]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is an even int' do
      let(:arguments_list) do
        [
          [0],
          [2],
          [2222]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
