# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#uuid_v6?" do
    let(:predicate_name) { :uuid_v6? }

    context "when value is a valid V6 UUID" do
      let(:arguments_list) do
        [["1ec9414c-232a-6b00-b3c8-9e6bdeced846"]]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value is not a valid V6 UUID" do
      let(:arguments_list) do
        [
          ["not-a-uuid-at-all\n1ec9414c-232a-6b00-b3c8-9e6bdeced846"], # V6 with invalid prefix
          ["1ec9414c-232a-6b00-b3c8-9e6bdeced846\nnot-a-uuid-at-all"], # V6 with invalid suffix
          ["1ec9414c-232a-3b00-b3c8-9e6bdeced846"], # wrong version number (3, not 6)
          ["20633928-6a07-11e9-a923-1681be663d3e"], # UUID V1
          ["not-a-uuid-at-all"]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
