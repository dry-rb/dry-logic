require 'dry/logic/predicate'

RSpec.shared_examples 'predicates' do
  let(:none?) { Dry::Logic::Predicate.new(:none?) { |value| value.nil? } }

  let(:str?) { Dry::Logic::Predicate.new(:str?) { |value| value.is_a?(String) } }

  let(:int?) { Dry::Logic::Predicate.new(:int?) { |value| value.is_a?(Fixnum) } }

  let(:filled?) { Dry::Logic::Predicate.new(:filled?) { |value| value.size > 0 } }

  let(:min_size?) { Dry::Logic::Predicate.new(:min_size?) { |size, value| value.size >= size } }

  let(:gt?) { Dry::Logic::Predicate.new(:gt?) { |num, value| value > num } }

  let(:lt?) { Dry::Logic::Predicate.new(:lt?) { |num, value| value < num } }

  let(:key?) { Dry::Logic::Predicate.new(:key?) { |key, hash| hash.key?(key) } }

  let(:eql?) { Dry::Logic::Predicate.new(:eql?) { |other, value| other == value } }
end
