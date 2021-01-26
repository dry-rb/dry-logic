# frozen_string_literal: true

require "dry/logic/build"

# TODO: Merge with {operation}?
RSpec.shared_examples "predicate" do
  let(:predicate) { Dry::Logic::Build.call(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { predicate.call(*args).success? }
  it { is_expected.to eq(output) }
end
