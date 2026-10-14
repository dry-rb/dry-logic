# frozen_string_literal: true

RSpec.describe Dry::Logic::Interner do
  subject(:interner) { described_class.new(storable: :frozen?.to_proc) }

  it "returns the first of equal values it stores" do
    first = interner.(%w[a b].freeze)

    expect(interner.(%w[a b].freeze)).to be(first)
    expect(interner.shared?(first)).to be(true)
  end

  it "answers an equal value it may not store with the stored one" do
    first = interner.(%w[a b].freeze)

    expect(interner.(%w[a b])).to be(first)
  end

  it "does not store a value it may not store" do
    value = %w[a b]

    expect(interner.(value)).to be(value)
    expect(interner.shared?(value)).to be(false)
    expect(interner.(%w[a b])).not_to be(value)
  end

  it "passes through a value that is not a candidate, without hashing it" do
    interner = described_class.new(candidate: ->(_) { false }, storable: ->(_) { true })
    value = Object.new
    def value.hash = raise("hashed")

    expect(interner.(value)).to be(value)
  end
end
