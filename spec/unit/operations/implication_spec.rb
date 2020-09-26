# frozen_string_literal: true

RSpec.describe Dry::Logic::Operations::Implication do
  subject(:operation) { described_class.new(left, right) }

  include_context "predicates"

  let(:left) { Dry::Logic::Rule::Predicate.build(int?) }
  let(:right) { Dry::Logic::Rule::Predicate.build(gt?).curry(18) }

  describe "#call" do
    it "calls left and right" do
      expect(operation.("19")).to be_success
      expect(operation.(19)).to be_success
      expect(operation.(18)).to be_failure
    end
  end

  describe "#to_ast" do
    it "returns ast" do
      expect(operation.to_ast).to eql(
        [:implication, [[:predicate, [:int?, [[:input, undefined]]]], [:predicate, [:gt?, [[:num, 18], [:input, undefined]]]]]]
      )
    end
  end

  describe "#to_s" do
    it "returns string representation" do
      expect(operation.to_s).to eql("int? THEN gt?(18)")
    end
  end
end
