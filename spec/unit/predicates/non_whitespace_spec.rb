require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#filled?' do
    let(:predicate_name) { :non_whitespace? }

    context 'when string contains non-whitespace characters' do
      let(:arguments_list) do
        [
          ['something'],
          ['0'],
          ['  with trailing whitespace   '],
          [:symbol]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when string contains no non-whitespace chars ' do
      let(:arguments_list) do
        [
          [''],
          [' '],
          ["\n"],
          ["\t"],
          [:""],
          [:"  "],
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
