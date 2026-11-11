# frozen_string_literal: true

RSpec.describe Dry::Logic::Evaluator do
  describe Dry::Logic::Evaluator::Key do
    it "reads a single key" do
      evaluator = described_class.new(:name)

      expect(evaluator.(name: "Jane")).to eql("Jane")
      expect(evaluator[name: "Jane"]).to eql("Jane")
    end

    it "reads a single key given as a path" do
      expect(described_class.new([:name]).(name: "Jane")).to eql("Jane")
    end

    it "reads a single nil key" do
      expect(described_class.new([nil]).(nil => "Jane")).to eql("Jane")
    end

    it "returns nil for a missing key" do
      expect(described_class.new(:name).({})).to be_nil
    end

    it "reads a nested path" do
      evaluator = described_class.new(%i[user address city])

      expect(evaluator.(user: {address: {city: "NYC"}})).to eql("NYC")
    end

    it "reads array indices in a path" do
      expect(described_class.new([:tags, 1]).(tags: %w[a b])).to eql("b")
    end

    it "returns the input for an empty path" do
      input = {name: "Jane"}

      expect(described_class.new([]).(input)).to be(input)
    end

    it "is equal to an evaluator with the same path" do
      expect(described_class.new(:name)).to eql(described_class.new([:name]))
    end
  end

  describe Dry::Logic::Evaluator::Set do
    it "reads each path" do
      evaluator = described_class.new([:name, %i[address city]])

      expect(evaluator.(name: "Jane", address: {city: "NYC"})).to eql(%w[Jane NYC])
    end
  end
end
