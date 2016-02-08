RSpec.describe Rule::Composite::Conjunction do
  include_context 'predicates'

  subject(:rule) { Rule::Composite::Conjunction.new(left, right) }

  let(:left) { Rule::Value.new(int?) }
  let(:right) { Rule::Value.new(gt?.curry(18)) }

  describe '#call' do
    it 'calls left and right' do
      expect(rule.(18)).to be_failure
    end
  end

  describe '#and' do
    let(:other) { Rule::Value.new(lt?.curry(30)) }

    it 'creates conjunction with the other' do
      expect(rule.and(other).(31)).to be_failure
    end
  end

  describe '#or' do
    let(:other) { Rule::Value.new(lt?.curry(14)) }

    it 'creates disjunction with the other' do
      expect(rule.or(other).(13)).to be_success
    end
  end
end
