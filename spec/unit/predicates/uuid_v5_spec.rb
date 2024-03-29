# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#uuid_v5?" do
    let(:predicate_name) { :uuid_v5? }

    context "when value is a valid V5 UUID" do
      let(:arguments_list) do
        [["f2d26c57-e07c-5416-a749-57e937930e04"]]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value is not a valid V5 UUID" do
      let(:arguments_list) do
        [
          ["not-a-uuid-at-all\nf2d26c57-e07c-5416-a749-57e937930e04"], # V5 with invalid prefix
          ["f2d26c57-e07c-5416-a749-57e937930e04\nnot-a-uuid-at-all"], # V5 with invalid suffix
          ["f2d26c57-e07c-3416-a749-57e937930e04"], # wrong version number (3, not 5)
          ["20633928-6a07-11e9-a923-1681be663d3e"], # UUID V1
          ["not-a-uuid-at-all"]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
