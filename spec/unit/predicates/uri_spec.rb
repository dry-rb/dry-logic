# frozen_string_literal: true

require 'dry/logic/predicates'

RSpec.describe Dry::Logic::Predicates do
  describe '#uri?' do
    let(:predicate_name) { :uri? }

    context 'when value is a valid URI' do
      let(:arguments_list) do
        [
          [nil, 'https://github.com/dry-rb/dry-logic'], # without schemes param
          ['https', 'https://github.com/dry-rb/dry-logic'], # with scheme param
          [['http', 'https'], 'https://github.com/dry-rb/dry-logic'], # with schemes array
          ['mailto', 'mailto:myemail@host.com'], # with mailto format
          ['urn', "urn:isbn:0451450523"] # with URN format
        ]
      end

      it_behaves_like 'a passing predicate'
    end

    context 'with value is not a valid URI' do
      let(:arguments_list) do
        [
          ['http', 'mailto:myemail@host.com'], # scheme not allowed
          [['http', 'https'], 'ftp:://myftp.com'], # scheme not allowed
          ['', 'not-a-uri-at-all']
        ]
      end

      it_behaves_like 'a failing predicate'
    end
  end
end
