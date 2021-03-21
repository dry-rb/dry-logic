# frozen_string_literal: true

require "dry/logic/builder"

RSpec.shared_examples "operation" do
  before { extend Dry::Logic::Builder }
  let(:operation) { build(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { operation.call(*args).success? }
  it { is_expected.to eq(output) }
end
