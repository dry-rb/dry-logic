require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#true?' do
    let(:predicate_name) { :true? }

    context 'when value is a date' do
      let(:arguments_list) do
        [[true]]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not true' do
      let(:arguments_list) do
        [
          [false],
          [''],
          [[]],
          [{}],
          [nil],
          [:symbol],
          [String],
          [1],
          [0],
          ['true'],
          ['false']
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
