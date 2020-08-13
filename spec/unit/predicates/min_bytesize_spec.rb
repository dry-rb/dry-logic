# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#min_bytesize?" do
    let(:predicate_name) { :min_bytesize? }

    context "when value size is greater than n" do
      let(:arguments_list) do
        [
          [3, "こa"]
        ]
      end

      it_behaves_like "a passing predicate"
    end

    context "when value size is equal to n" do
      let(:arguments_list) do
        [
          [5, "こab"]
        ]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value size is less than n" do
      let(:arguments_list) do
        [
          [5, "こ"]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
