# frozen_string_literal: true

require "dry/logic/builder"

# TODO: Merge with {operation}?
RSpec.shared_examples "predicate" do
  before { extend Dry::Logic::Builder }
  let(:predicate) { build(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { predicate.call(*args).success? }
  it { is_expected.to eq(output) }
end
