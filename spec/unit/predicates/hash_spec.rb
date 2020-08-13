# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#hash?" do
    let(:predicate_name) { :hash? }

    context "when value is a hash" do
      let(:arguments_list) do
        [
          [{}],
          [foo: :bar],
          [{}]
        ]
      end

      it_behaves_like "a passing predicate"
    end

    context "when value is not a hash" do
      let(:arguments_list) do
        [
          [""],
          [[]],
          [nil],
          [:symbol],
          [String],
          [1],
          [1.0],
          [true],
          [[]],
          [Hash]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
