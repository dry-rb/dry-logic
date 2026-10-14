# frozen_string_literal: true

RSpec.describe Dry::Logic::Interner do
  subject(:interner) { described_class.new(&:frozen?) }

  it "returns the first of equal values it is given" do
    first = interner.(%w[a b].freeze)

    expect(interner.(%w[a b].freeze)).to be(first)
  end

  it "passes through a value it may not share" do
    value = %w[a b]

    expect(interner.(value)).to be(value)
    expect(interner.(%w[a b])).not_to be(value)
  end
end
