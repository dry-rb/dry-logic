# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates, '#format?' do
  let(:predicate_name) { :format? }

  context 'when value matches provided regexp' do
    let(:arguments_list) do
      [[/^F/, 'Foo']]
    end

    it_behaves_like 'a passing predicate'
  end

  context 'when value does not match provided regexp' do
    let(:arguments_list) do
      [[/^F/, 'Bar']]
    end

    it_behaves_like 'a failing predicate'
  end

  context 'when input is nil' do
    let(:arguments_list) do
      [[/^F/, nil]]
    end

    it_behaves_like 'a failing predicate'
  end
end
