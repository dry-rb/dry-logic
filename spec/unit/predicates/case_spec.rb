# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#case?' do
    let(:predicate_name) { :case? }

    context 'when the value matches the pattern' do
      let(:arguments_list) do
        [
          [11, 11],
          [:odd?.to_proc, 11],
          [/\Af/, 'foo'],
          [Integer, 11]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context "when the value doesn't match the pattern" do
      let(:arguments_list) do
        [
          [13, 14],
          [:odd?.to_proc, 12],
          [/\Af/, 'bar'],
          [String, 11]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
