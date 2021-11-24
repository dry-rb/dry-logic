# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#size?" do
    let(:predicate_name) { :size? }

    context "when value size is equal to n" do
      let(:arguments_list) do
        [
          [[2, 4, 6], "abcd"],
          [4, "Jill"],
          [2, {1 => "st", 2 => "nd"}],
          [1..8, "qwerty"]
        ]
      end

      it_behaves_like "a passing predicate"
    end

    context "when value size is greater than n" do
      let(:arguments_list) do
        [
          [[1, 2], "abc"],
          [5, "Jill"],
          [3, {1 => "st", 2 => "nd"}],
          [1..5, "qwerty"]
        ]
      end

      it_behaves_like "a failing predicate"
    end

    context "with value size is less than n" do
      let(:arguments_list) do
        [
          [[1, 2], 1],
          [3, "Jill"],
          [1, {1 => "st", 2 => "nd"}],
          [1..5, "qwerty"]
        ]
      end

      it_behaves_like "a failing predicate"
    end

    context "with an unsupported size" do
      it "raises an error" do
        expect { Dry::Logic::Predicates[:size?].call("oops", 1) }.to raise_error(ArgumentError, /oops/)
      end
    end
  end
end
