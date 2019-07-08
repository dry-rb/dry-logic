# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#bytesize?' do
    let(:predicate_name) { :bytesize? }

    context 'when value size is equal to n' do
      let(:arguments_list) do
        [
          [4, 'こa'],
          [1..8,  'こa']
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when value size is greater than n' do
      let(:arguments_list) do
        [
          [3, 'こa'],
          [1..3,  'こa']
        ]
      end

      it_behaves_like 'a failing predicate'
    end

    context 'with value size is less than n' do
      let(:arguments_list) do
        [
          [5, 'こa'],
          [5..10,  'こa']
        ]
      end

      it_behaves_like 'a failing predicate'
    end

    context 'with an unsupported size' do
      it 'raises an error' do
        expect { Predicates[:bytesize?].call('oops', 1) }.to raise_error(ArgumentError, /oops/)
      end
    end
  end
end
