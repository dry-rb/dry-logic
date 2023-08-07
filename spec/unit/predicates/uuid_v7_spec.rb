# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#uuid_v7?" do
    let(:predicate_name) { :uuid_v7? }

    context "when value is a valid V7 UUID" do
      let(:arguments_list) do
        [["017f22e2-79b0-7cc3-98c4-dc0c0c07398f"]]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value is not a valid V7 UUID" do
      let(:arguments_list) do
        [
          ["not-a-uuid-at-all\n017f22e2-79b0-7cc3-98c4-dc0c0c07398f"], # V6 with invalid prefix
          ["017f22e2-79b0-7cc3-98c4-dc0c0c07398f\nnot-a-uuid-at-all"], # V6 with invalid suffix
          ["017f22e2-79b0-4cc3-98c4-dc0c0c07398f"], # wrong version number (4, not 7)
          ["20633928-6a07-11e9-a923-1681be663d3e"], # UUID V1
          ["not-a-uuid-at-all"]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
