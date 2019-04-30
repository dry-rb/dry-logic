# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#bool?' do
    let(:predicate_name) { :bool? }

    context 'when value is a boolean' do
      let(:arguments_list) do
        [[true], [false]]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when value is not a bool' do
      let(:arguments_list) do
        [
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
