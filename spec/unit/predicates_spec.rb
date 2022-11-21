# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  it "can be included in another module" do
    mod = Module.new { include Dry::Logic::Predicates }

    expect(mod[:key?]).to be_a(Method)
  end

  describe ".predicate" do
    it "defines a predicate method" do
      mod = Module.new {
        include Dry::Logic::Predicates

        predicate(:test?) do |foo|
          true
        end
      }

      expect(mod.test?("arg")).to be(true)
    end
  end

  describe ".respond_to?" do
    it "works with a just the method name" do
      expect(Dry::Logic::Predicates.respond_to?(:predicate)).to be(true)
      expect(Dry::Logic::Predicates.respond_to?(:not_here)).to be(false)
    end
  end
end
