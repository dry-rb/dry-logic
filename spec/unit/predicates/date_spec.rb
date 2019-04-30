# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#date?' do
    let(:predicate_name) { :date? }

    context 'when value is a date' do
      let(:arguments_list) do
        [[Date.today]]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not an integer' do
      let(:arguments_list) do
        [
          [''],
          [[]],
          [{}],
          [nil],
          [:symbol],
          [String],
          [1]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
