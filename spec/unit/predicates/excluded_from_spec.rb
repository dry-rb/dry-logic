# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#excluded_from?' do
    let(:predicate_name) { :excluded_from? }

    context 'when value is not present in list' do
      let(:arguments_list) do
        [
          [['Jill', 'John'], 'Jack'],
          [1..2, 0],
          [1..2, 3],
          [[nil, false], true]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is present in list' do
      let(:arguments_list) do
        [
          [['Jill', 'John'], 'Jill'],
          [['Jill', 'John'], 'John'],
          [1..2, 1],
          [1..2, 2],
          [[nil, false], nil],
          [[nil, false], false]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
