# frozen_string_literal: true

RSpec.describe Dry::Logic::Builder do
  describe "undefined methods" do
    it "raises NameError" do
      expect do
        described_class.call { does_not_exist }
      end.to raise_error(NameError, /does_not_exist/)
    end
  end

  describe "leakage" do
    context "given a module extending ::Builder" do
      subject do
        Module.new do
          extend Dry::Logic::Builder
        end
      end

      it { is_expected.not_to respond_to(:int?) }
      it { is_expected.to respond_to(:call) }
      it { is_expected.to respond_to(:build) }
    end
  end

  describe "ast of built rule" do
    let(:expression) { -> (*) { key?(:speed) } }
    it_behaves_like "built rule", :predicate, :key?, [:name, :speed]
  end
end
