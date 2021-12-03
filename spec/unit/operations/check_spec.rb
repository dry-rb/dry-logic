# frozen_string_literal: true

RSpec.describe Dry::Logic::Operations::Check do
  include_context "predicates"

  describe "#call" do
    context "with 1-level nesting" do
      subject(:operation) do
        described_class.new(Dry::Logic::Rule::Predicate.build(eq?).curry(1), id: :compare, keys: [:num])
      end

      it "applies predicate to args extracted from the input" do
        expect(operation.(num: 1)).to be_success
        expect(operation.(num: 2)).to be_failure
      end
    end

    context "with 2-levels nesting" do
      subject(:operation) do
        described_class.new(
          Dry::Logic::Rule::Predicate.build(eq?), id: :compare, keys: [[:nums, :left], [:nums, :right]]
        )
      end

      it "applies predicate to args extracted from the input" do
        expect(operation.(nums: {left: 1, right: 1})).to be_success
        expect(operation.(nums: {left: 1, right: 2})).to be_failure
      end

      it "curries args properly" do
        result = operation.(nums: {left: 1, right: 2})

        expect(result.to_ast).to eql(
          [:failure, [:compare, [:check, [
            [[:nums, :left], [:nums, :right]], [:predicate, [:eq?, [[:left, 1], [:right, 2]]]]
          ]]]]
        )
      end
    end

    context "with its output as input" do
      let(:gt?) { Dry::Logic::Predicates[:gt?] }
      let(:min) { Dry::Logic::Rule::Predicate.new(gt?).curry(18) }
      let(:inner) { described_class.new(min, keys: [:age]) }
      let(:outer) { described_class.new(inner, keys: [:person]) }

      subject { outer.call(input) }

      describe "success" do
        let(:input) { {person: {age: 20}} }
        it { is_expected.to be_a_success }
      end

      describe "failure" do
        let(:input) { {person: {age: 10}} }
        it { is_expected.not_to be_a_success }
      end
    end
  end

  describe "#to_ast" do
    subject(:operation) do
      described_class.new(Dry::Logic::Rule::Predicate.build(str?), keys: [:email])
    end

    it "returns ast" do
      expect(operation.to_ast).to eql(
        [:check, [[:email], [:predicate, [:str?, [[:input, undefined]]]]]]
      )
    end
  end
end
