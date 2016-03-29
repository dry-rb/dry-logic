require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#number?' do
    let(:predicate_name) { :number? }

    context 'when value is numerical' do
      let(:arguments_list) do
        [
          ["34"],
          ["1.000004"],
          ["0"],
          [4],
          ["-15.24"],
          [-3.5]
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not numerical' do
      let(:arguments_list) do
        [
          [''],
          ["-14px"],
          ["10,150.00"],
          [nil],
          [:symbol],
          [String]
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
