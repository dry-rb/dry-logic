RSpec.describe Rule::Check do
  include_context 'predicates'

  let(:other) do
    Rule::Value.new(:name, none?).or(Rule::Value.new(:name, filled?))
  end

  describe '#call' do
    subject(:rule) do
      Rule::Check::Unary.new(:name, other.(input).curry(predicate), [:name])
    end

    context 'when the given predicate passed' do
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

  describe '#call with a nested result' do
    subject(:rule) do
      Rule::Check::Binary.new(:address, result, [:user, { user: :address }])
    end

    let(:other) { Rule::Value.new(:user, hash?) }
    let(:result) { other.(input).curry(:hash?) }
    let(:input) { { address: 'Earth' } }

    it 'evaluates the input' do
      expect(rule.(user: result).to_ary).to eql([
        :input, [
          :address, { address: 'Earth' },
          [
            [:check, [
              :address, [
                :input, [:user, { address: 'Earth' }, [
                  [:val, [:user, [:predicate, [:hash?, []]]]]]]]
            ]]
          ]
        ]
      ])
    end
  end
end
