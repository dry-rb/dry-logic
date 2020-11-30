# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.describe Dry::Logic::Predicates do
  describe "#attr?" do
    let(:predicate_name) { :attr? }

    context "when input responds to the attr name" do
      let(:arguments_list) do
        [
          [:name, Struct.new(:name).new("John")],
          [:age, Struct.new(:age).new(18)]
        ]
      end

      it_behaves_like "a passing predicate"

      context "and value matches the attr value" do
        let(:arguments_list) do
          [
            [:name, "John", Struct.new(:name).new("John")],
            [:age, 18, Struct.new(:age).new(18)]
          ]
        end

        it_behaves_like "a passing predicate"
      end

      context "and value does not matche the attr value" do
        let(:arguments_list) do
          [
            [:name, "Jill", Struct.new(:name).new("John")],
            [:age, 21, Struct.new(:age).new(18)]
          ]
        end

        it_behaves_like "a failing predicate"
      end
    end

    context "when input does not respond to the attr name" do
      let(:arguments_list) do
        [
          [:name, Struct.new(:age).new(18)],
          [:age, Struct.new(:name).new("Jill")]
        ]
      end

      it_behaves_like "a failing predicate"

      context "and value does not matche the attr value" do
        let(:arguments_list) do
          [
            [:name, "Jill", Struct.new(:age).new(18)],
            [:age, 18, Struct.new(:name).new("Jill")]
          ]
        end

        it_behaves_like "a failing predicate"
      end
    end
  end
end
