# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#respond_to?' do
    let(:predicate_name) { :respond_to? }

    context 'when value responds to method' do
      let(:arguments_list) do
        [
          [:method, Object],
          [:new, Hash]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'when value does not respond to method' do
      let(:arguments_list) do
        [
          [:foo, Object],
          [:bar, Hash]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
