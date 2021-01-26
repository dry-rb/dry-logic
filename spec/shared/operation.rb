# frozen_string_literal: true

require "dry/logic/build"

RSpec.shared_examples "operation" do
  let(:operation) { Dry::Logic::Build.call(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { operation.call(*args).success? }
  it { is_expected.to eq(output) }
end
