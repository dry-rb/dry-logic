# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#attr?' do
    let(:predicate_name) { :attr? }

    context 'when value responds to the attr name' do
      let(:arguments_list) do
        [
          [:name, Struct.new(:name).new('John')],
          [:age, Struct.new(:age).new(18)]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value does not respond to the attr name' do
      let(:arguments_list) do
        [
          [:name, Struct.new(:age).new(18)],
          [:age, Struct.new(:name).new('Jill')]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
