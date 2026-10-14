# frozen_string_literal: true

RSpec.describe Dry::Logic::Operations::Abstract, ".new" do
  let(:str?) { Dry::Logic::Rule::Predicate.build(Dry::Logic::Predicates[:str?]) }
  let(:filled?) { Dry::Logic::Rule::Predicate.build(Dry::Logic::Predicates[:filled?]) }

  it "returns the same operation for equal rules and options" do
    expect(str? & filled?).to be(str? & filled?)
    expect(Dry::Logic::Operations::Key.new(str?, name: :email))
      .to be(Dry::Logic::Operations::Key.new(str?, name: :email))
  end

  it "keeps operations with different options apart" do
    expect(Dry::Logic::Operations::Key.new(str?, name: :email))
      .not_to be(Dry::Logic::Operations::Key.new(str?, name: :name))
  end

  it "does not share an operation holding a rule that is not shared" do
    unshared = Dry::Logic::Rule::Predicate.build(
      Dry::Logic::Predicates[:max_size?], args: [Object.new.freeze]
    )

    expect(str? & unshared).not_to be(str? & unshared)
  end

  it "freezes the evaluator a key operation reads with" do
    expect(Dry::Logic::Operations::Key.new(str?, name: :email).evaluator).to be_frozen
  end
end
