# frozen_string_literal: true

require "dry/logic/builder"

RSpec.shared_examples "built rule" do |rule_type, *args|
  subject(:built_rule) { Dry::Logic::Builder.call(&expression) }
  let(:rule_type) { rule_type }

  case rule_type
  when :predicate
    include_examples "built rule predicate", *args
  else
    include_examples "built rule operation", *args
  end

  describe "#to_ast" do
    subject(:ast) { built_rule.to_ast }
    it { is_expected.to include(rule_type, rule_node) }
  end
end

RSpec.shared_examples "built rule predicate" do |predicate_name, *args|
  it { is_expected.to be_kind_of(Dry::Logic::Rule::Predicate) }
  let(:predicate_name) { predicate_name }
  let(:rule_node) { [predicate_name, include(*args)] }

  describe "#predicate" do
    subject(:predicate) { built_rule.predicate }

    describe "#name" do
      subject(:name) { predicate.name }
      it { is_expected.to eq(predicate_name) }
    end
  end
end

RSpec.shared_examples "built rule operation" do |node|
  it { is_expected.to be_kind_of(Dry::Logic::Operation::Abstract) }
  let(:rule_node) { node }
end
