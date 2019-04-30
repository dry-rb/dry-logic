# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#type?' do
    let(:predicate_name) { :type? }

    context 'when value has a correct type' do
      let(:arguments_list) do
        [[TrueClass, true]]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not true' do
      let(:arguments_list) do
        [
          [TrueClass, false],
          [TrueClass, ''],
          [TrueClass, []],
          [TrueClass, {}],
          [TrueClass, nil],
          [TrueClass, :symbol],
          [TrueClass, String],
          [TrueClass, 1],
          [TrueClass, 0],
          [TrueClass, 'true'],
          [TrueClass, 'false']
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
