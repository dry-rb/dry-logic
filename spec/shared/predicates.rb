require 'dry/logic/predicates'

RSpec.shared_examples 'predicates' do
  let(:none?) { Dry::Logic::Predicates[:none?] }

  let(:str?) { Dry::Logic::Predicates[:str?] }

  let(:true?) { Dry::Logic::Predicates[:true?] }

  let(:hash?) { Dry::Logic::Predicates[:hash?] }

  let(:int?) { Dry::Logic::Predicates[:int?] }

  let(:filled?) { Dry::Logic::Predicates[:filled?] }

  let(:min_size?) { Dry::Logic::Predicates[:min_size?] }

  let(:lt?) { Dry::Logic::Predicates[:lt?] }

  let(:gt?) { Dry::Logic::Predicates[:gt?] }

  let(:key?) { Dry::Logic::Predicates[:key?] }

  let(:attr?) { Dry::Logic::Predicates[:attr?] }

  let(:eql?) { Dry::Logic::Predicates[:eql?] }
end

RSpec.shared_examples 'a passing predicate' do
  let(:predicate) { Dry::Logic::Predicates[predicate_name] }

  it do
    arguments_list.each do |args|
      expect(predicate.call(*args).result).to be(true)
    end
  end
end

RSpec.shared_examples 'a failing predicate' do
  let(:predicate) { Dry::Logic::Predicates[predicate_name] }

  it do
    arguments_list.each do |args|
      expect(predicate.call(*args).result).to be(false)
    end
  end
end
