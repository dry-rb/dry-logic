# frozen_string_literal: true

RSpec.describe Dry::Logic::Rule::Predicate, ".build" do
  let(:str?) { Dry::Logic::Predicates[:str?] }
  let(:max_size?) { Dry::Logic::Predicates[:max_size?] }
  let(:included_in?) { Dry::Logic::Predicates[:included_in?] }

  it "returns the same rule for an equal predicate and args" do
    expect(described_class.build(str?)).to be(described_class.build(str?))
    expect(described_class.build(max_size?).curry(255))
      .to be(described_class.build(max_size?).curry(255))
  end

  it "keeps rules with different args apart" do
    expect(described_class.build(max_size?).curry(255))
      .not_to be(described_class.build(max_size?).curry(256))
  end

  it "does not share a rule whose args are not frozen" do
    list = %w[a b]

    expect(described_class.build(included_in?).curry(list))
      .not_to be(described_class.build(included_in?).curry(list))
  end

  it "does not share a rule built with an args array that is not frozen" do
    expect(described_class.build(max_size?, args: [5]))
      .not_to be(described_class.build(max_size?, args: [5]))
  end
end
