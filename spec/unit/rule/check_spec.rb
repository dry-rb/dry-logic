RSpec.describe Rule::Check do
  include_context 'predicates'

  describe '#call' do
    context 'with 1-level nesting' do
      subject(:rule) do
        Rule::Check.new(eql?, name: :compare, keys: [:left, :right])
      end

      it 'applies predicate to args extracted from the input' do
        expect(rule.(left: 1, right: 1)).to be_success
        expect(rule.(left: 1, right: 2)).to be_failure
      end
    end

    context 'with 2-levels nesting' do
      subject(:rule) do
        Rule::Check.new(eql?, name: :compare, keys: [[:nums, :left], [:nums, :right]])
      end

      it 'applies predicate to args extracted from the input' do
        expect(rule.(nums: { left: 1, right: 1 })).to be_success
        expect(rule.(nums: { left: 1, right: 2 })).to be_failure
      end

      it 'curries args properly' do
        result = rule.(nums: { left: 1, right: 2 })

        expect(result.to_ary).to eql([
          :input, [:compare, [
            :result, [1, [:check, [:compare, [:predicate, [:eql?, [2]]]]]]]
          ]
        ])
      end
    end
  end
end
