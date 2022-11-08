# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#uuid_v3?" do
    let(:predicate_name) { :uuid_v3? }

    context "when value is a valid V3 UUID" do
      let(:arguments_list) do
        [["f2d26c57-e07c-3416-a749-57e937930e04"]]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value is not a valid V4 UUID" do
      let(:arguments_list) do
        [
          ["not-a-uuid-at-all\nf2d26c57-e07c-3416-a749-57e937930e04"], # V3 with invalid prefix
          ["f2d26c57-e07c-3416-a749-57e937930e04\nnot-a-uuid-at-all"], # V3 with invalid suffix
          ["f2d26c57-e07c-4416-a749-57e937930e04"], # wrong version number (4, not 3)
          ["20633928-6a07-11e9-a923-1681be663d3e"], # UUID V1
          ["not-a-uuid-at-all"],
          [Hash.new] # Not even a string
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
