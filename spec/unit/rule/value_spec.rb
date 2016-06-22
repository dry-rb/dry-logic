require 'dry/logic/rule'

RSpec.describe Dry::Logic::Rule::Value do
  include_context 'predicates'

  let(:is_nil) { Dry::Logic::Rule::Value.new(none?) }

  let(:is_string) { Dry::Logic::Rule::Value.new(str?) }

  let(:min_size) { Dry::Logic::Rule::Value.new(min_size?) }

  describe '#call' do
    it 'returns result of a predicate' do
      expect(is_string.(1)).to be_failure
      expect(is_string.('1')).to be_success
    end

    context 'with a composite rule' do
      subject(:rule) { Dry::Logic::Rule::Value.new(is_nil | is_string) }

      it 'returns a success for valid input' do
        expect(rule.(nil)).to be_success
        expect(rule.('foo')).to be_success
      end

      it 'returns a failure for invalid input' do
        expect(rule.(312)).to be_failure
      end

      it 'returns a failure result with curried args' do
        expect(rule.(312).to_ast).to eql(
          [:result, [312, [:val, [:predicate, [:str?, [[:input, 312]]]]]]]
        )
      end
    end

    context 'with a custom predicate' do
      subject(:rule) { Dry::Logic::Rule::Value.new(predicate) }

      let(:response) { double("response", success?: true) }
      let(:predicate) { double("predicate", arity: 1, curry: curried, call: Result.new(response, double("rule"), test: true)) }
      let(:curried) { double("curried", arity: 1, call: Result.new(response, double("rule"), test: true)) }

      let(:result) { rule.(test: true) }

      it 'calls its predicate returning custom result' do
        expect(result).to be_success
      end

      it 'exposes access to nested result' do
        expect(response).to receive(:[]).with(:foo).and_return(:bar)
        expect(result[:foo]).to be(:bar)
      end

      it 'returns nil from [] when response does not respond to it' do
        expect(result[:foo]).to be(nil)
      end

      it 'has no name by default' do
        expect(result.name).to be(nil)
      end

      context "works with predicates.arity == 0" do
        subject(:rule) { Dry::Logic::Rule::Value.new(predicate) }

        let(:predicate) { Dry::Logic::Predicate.new(:without_args) { true } }
        let(:result) { rule.('sutin') }

        it "calls its predicate without any args" do
          expect(result).to be_success
        end
      end
    end
  end

  describe '#and' do
    it 'returns a conjunction' do
      string_and_min_size = is_string.and(min_size.curry(3))

      expect(string_and_min_size.('abc')).to be_success
      expect(string_and_min_size.('abcd')).to be_success

      expect(string_and_min_size.(1)).to be_failure
      expect(string_and_min_size.('ab')).to be_failure
    end
  end

  describe '#or' do
    it 'returns a disjunction' do
      nil_or_string = is_nil.or(is_string)

      expect(nil_or_string.(nil)).to be_success
      expect(nil_or_string.('abcd')).to be_success

      expect(nil_or_string.(true)).to be_failure
      expect(nil_or_string.(1)).to be_failure
    end
  end
end
