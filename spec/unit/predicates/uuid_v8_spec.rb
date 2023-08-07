# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#uuid_v8?" do
    let(:predicate_name) { :uuid_v8? }

    context "when value is a valid V8 UUID" do
      let(:arguments_list) do
        [["320c3d4d-cc00-875b-8ec9-32d5f69181c0"]]
      end

      it_behaves_like "a passing predicate"
    end

    context "with value is not a valid V8 UUID" do
      let(:arguments_list) do
        [
          ["not-a-uuid-at-all\n320c3d4d-cc00-875b-8ec9-32d5f69181c0"], # V6 with invalid prefix
          ["320c3d4d-cc00-875b-8ec9-32d5f69181c0\nnot-a-uuid-at-all"], # V6 with invalid suffix
          ["320c3d4d-cc00-475b-8ec9-32d5f69181c0"], # wrong version number (4, not 8)
          ["20633928-6a07-11e9-a923-1681be663d3e"], # UUID V1
          ["not-a-uuid-at-all"]
        ]
      end

      it_behaves_like "a failing predicate"
    end
  end
end
