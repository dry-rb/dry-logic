RSpec.describe Rule::Check do
  subject(:rule) do
    Rule::Check::Unary.new(:name, other.(input).curry(predicate), [:name])
  end

  include_context 'predicates'

  let(:other) do
    Rule::Value.new(:name, none?).or(Rule::Value.new(:name, filled?))
  end

  describe '#call' do
    context 'when then given predicate passed' do
      let(:input) { 'Jane' }
      let(:predicate) { :filled? }

      it 'returns a success' do
        expect(rule.('Jane')).to be_success
      end
    end

    context 'when the given predicate did not pass' do
      let(:input) { nil }
      let(:predicate) { :filled? }

      it 'returns a failure' do
        expect(rule.(nil)).to be_failure
      end
    end
  end
end
