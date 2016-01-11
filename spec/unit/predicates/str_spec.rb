require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#str?' do
    let(:predicate_name) { :str? }

    context 'when value is a string' do
      let(:arguments_list) do
        [
          [''],
          ['John']
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not a string' do
      let(:arguments_list) do
        [
          [[]],
          [{}],
          [nil],
          [:symbol],
          [String]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
