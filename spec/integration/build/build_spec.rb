# frozen_string_literal: true

require "dry/logic/build"

RSpec.describe ".build" do
  subject { predicate.call(described_class) }
  before { extend Dry::Logic::Build }

  describe "nested operations" do
    let(:predicate) do
      build do
        check keys: [:person] do
          check keys: [:age] do
            gt?(50) & lt?(200)
          end
        end
      end
    end

    describe({person: {age: 100}}) do
      it { is_expected.to be_a_success }
    end

    describe({person: {age: 10}}) do
      it { is_expected.not_to be_a_success }
    end
  end

  describe "operations" do
    let(:predicate) do
      build do
        int? | float? | number?
      end
    end

    describe 1 do
      it { is_expected.to be_a_success }
    end

    describe 2.0 do
      it { is_expected.to be_a_success }
    end

    describe "3" do
      it { is_expected.not_to be_a_success }
    end

    describe "four" do
      it { is_expected.not_to be_a_success }
    end
  end

  describe "predicates" do
    let(:predicate) do
      build { even? }
    end

    describe 10 do
      it { is_expected.to be_a_success }
    end

    describe 5 do
      it { is_expected.not_to be_a_success }
    end
  end
end
