# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#false?' do
    let(:predicate_name) { :false? }

    context 'when value is false' do
      let(:arguments_list) do
        [[false]]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when value is not false' do
      let(:arguments_list) do
        [
          [true],
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
