RSpec.describe Rule::ExclusiveDisjunction do
  include_context 'predicates'

  subject(:rule) do
    Rule::ExclusiveDisjunction.new(left, right)
  end

  let(:left) { Rule::Key.new(true?, name: :eat_cake) }
  let(:right) { Rule::Key.new(true?, name: :have_cake) }

  describe '#call' do
    it 'calls left and right' do
      expect(rule.(eat_cake: true, have_cake: false)).to be_success
      expect(rule.(eat_cake: false, have_cake: true)).to be_success
      expect(rule.(eat_cake: false, have_cake: false)).to be_failure
      expect(rule.(eat_cake: true, have_cake: true)).to be_failure
    end
  end
end
