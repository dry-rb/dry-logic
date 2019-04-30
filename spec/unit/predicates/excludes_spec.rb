# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#excludes?' do
    let(:predicate_name) { :excludes? }

    context 'with input excludes value' do
      let(:arguments_list) do
        [
          ['Jack', ['Jill', 'John']],
          [0, 1..2],
          [3, 1..2],
          ['foo', 'Hello World'],
          [:foo, { bar: 0 }],
          [true, [nil, false]]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with input of invalid type' do
      let(:arguments_list) do
        [
          [2, 1],
          [1, nil],
          ["foo", 1],
          [1, "foo"],
          [1..2, "foo"],
          ["foo", 1..2],
          [:key, "foo"]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when input includes value' do
      let(:arguments_list) do
        [
          ['Jill', ['Jill', 'John']],
          ['John', ['Jill', 'John']],
          [1, 1..2],
          [2, 1..2],
          ['Hello', 'Hello World'],
          ['World', 'Hello World'],
          [:bar, { bar: 0 }],
          [nil, [nil, false]],
          [false, [nil, false]]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
