# frozen_string_literal: true

RSpec.describe Operations::Attr do
  subject(:operation) { Operations::Attr.new(Rule::Predicate.build(str?), name: :name) }

  include_context 'predicates'

  let(:model) { Struct.new(:name) }

  describe '#call' do
    it 'applies predicate to the value' do
      expect(operation.(model.new('Jane'))).to be_success
      expect(operation.(model.new(nil))).to be_failure
    end
  end

  describe '#and' do
    let(:other) { Operations::Attr.new(Rule::Predicate.build(min_size?).curry(3), name: :name) }

    it 'returns and where value is passed to the right' do
      present_and_string = operation.and(other)

      expect(present_and_string.(model.new('Jane'))).to be_success

      expect(present_and_string.(model.new('Ja'))).to be_failure
      expect(present_and_string.(model.new(1))).to be_failure
    end
  end
end
