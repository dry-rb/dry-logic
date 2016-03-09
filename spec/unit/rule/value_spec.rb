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

    context 'with a custom predicate' do
      subject(:rule) { Dry::Logic::Rule::Value.new(predicate) }

      let(:response) { double(success?: true) }
      let(:predicate) { -> input { Result.new(response, double, input) } }

      let(:result) { rule.(test: true) }

      it 'calls its predicate returning custom result' do
        expect(result).to be_success
      end

      it 'exposes access to nested result' do
        expect(response).to receive(:[]).with(:foo).and_return(:bar)
        expect(result[:foo]).to be(:bar)
      end

      it 'has no name by default' do
        expect(result.name).to be(nil)
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
