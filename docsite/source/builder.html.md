---
title: Builder
layout: gem-single
name: dry-logic
---

## Example

``` ruby
extend Build

is_num = build do
  int? | float? | number?
end

is_num.call(10).success? # => true
is_num.call('ten').success? # => false
```

## Predicate & operation builder

``` ruby
require 'dry/logic/predicates'
require 'dry/inflector'
require 'dry/logic'
require 'date'

module Build
  include ::Dry::Logic

  def call(&block)
    Operation.call(&block)
  rescue NoMethodError
    Predicate.call(&block)
  end

  module_function :call
  alias build call

  class Base < BasicObject
    include ::Dry::Logic

    def self.call(&block)
      new.instance_eval(&block)
    end

    def self.const_missing(name)
      ::Object.const_get(name)
    end

    def predicate(...)
      Predicates[:predicate].call(...)
    end
  end

  class Predicate < Base
    def method_missing(method, *args, **kwargs, &block)
      super unless respond_to_missing?(method) || !Kernel.block_given?

      to_predicate(method).curry(*args)
    end

    def respond_to_missing?(method, *)
      to_predicate(method)
    rescue NameError
      false
    end

    private

    def to_predicate(name)
      Rule::Predicate.new(Predicates[name])
    end
  end

  class Operation < Base
    INFLECTOR = Dry::Inflector.new.freeze

    def method_missing(method, *args, **kwargs, &block)
      super unless respond_to_missing?(method) || !Kernel.block_given?

      to_operation(method).new(*to_predicate(&block), *args, **kwargs)
    end

    def respond_to_missing?(method, *)
      !to_operation(method).nil?
    rescue NameError
      false
    end

    private

    def to_operation(name)
      Kernel.eval(INFLECTOR.camelize("operations/#{name}"))
    end

    def to_predicate(&block)
      Predicate.call(&block)
    end
  end
end
```

## Specs

``` ruby
RSpec.shared_examples 'predicate' do
  let(:predicate) { Build.call(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { predicate.call(*args).success? }
  it { is_expected.to eq(output) }
end

RSpec.shared_examples 'operation' do
  let(:operation) { Build.call(&expression) }
  let(:args) { defined?(input) ? [input] : [] }
  subject { operation.call(*args).success? }
  it { is_expected.to eq(output) }
end

describe '.build' do
  before { extend Build }
  subject { predicate.call(described_class) }

  describe "operations" do
    let(:predicate) do
      build do
        int? | float? | number?
      end
    end

    describe 1 do
      it { is_expected.to be_a_success }
    end

    describe 2.0 do
      it { is_expected.to be_a_success }
    end

    describe '3' do
      it { is_expected.not_to be_a_success }
    end

    describe 'four' do
      it { is_expected.not_to be_a_success }
    end
  end

  describe "predicates" do
    let(:predicate) do
      build { even? }
    end

    describe 10 do
      it { is_expected.to be_a_success }
    end

    describe 5 do
      it { is_expected.not_to be_a_success }
    end
  end

  describe ".predicate" do
    before do
      build do
        predicate :divisible_with? do |num, input|
          (input % num).zero?
        end
      end
    end

    let(:predicate) do
      build do
        divisible_with?(10)
      end
    end

    describe 10 do
      it { is_expected.to be_a_success }
    end

    describe 5 do
      it { is_expected.not_to be_a_success }
    end
  end
end

describe 'predicates' do
  let(:input) { described_class }

  describe :key? do
    let(:expression) { ->(*) { key?(:speed) } }

    describe 'success' do
      let(:output) { true }

      describe({ speed: 100 }) do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe({ age: 50 }) do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :format? do
    let(:expression) { ->(*) { format?(/^(A|B)$/) } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { 'A' }
      end

      it_behaves_like 'predicate' do
        let(:input) { 'B' }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { 'C' }
      end

      it_behaves_like 'predicate' do
        let(:input) { 'D' }
      end
    end
  end

  describe :type? do
    let(:expression) { ->(*) { type?(String) } }

    describe 'success' do
      let(:output) { true }

      describe 'string' do
        it_behaves_like 'predicate' do
          let(:input) { 'string' }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { :symbol }
      end
    end
  end

  describe :nil? do
    let(:expression) { ->(*) { nil? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { nil }
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe :symbol do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :attr? do
    let(:expression) { ->(*) { attr?(:name) } }

    describe 'success' do
      let(:output) { true }

      describe Struct.new(:name).new('John') do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe Struct.new(:age).new(50) do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :empty? do
    let(:expression) { ->(*) { empty? } }

    describe 'success' do
      let(:output) { true }

      describe({}) do
        it_behaves_like 'predicate'
      end

      describe String do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end

      describe [] do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }
      describe({ key: 'value' }) do
        it_behaves_like 'predicate'
      end

      describe 'string' do
        it_behaves_like 'predicate'
      end

      describe nil do
        it_behaves_like 'predicate'
      end

      describe [1, 2] do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :filled? do
    let(:expression) { ->(*) { filled? } }

    describe 'success' do
      let(:output) { true }
      describe({ key: 'value' }) do
        it_behaves_like 'predicate'
      end

      describe 'string' do
        it_behaves_like 'predicate'
      end

      describe nil do
        it_behaves_like 'predicate'
      end

      describe [1, 2] do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }
      describe({}) do
        it_behaves_like 'predicate'
      end

      describe String do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end

      describe [] do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :bool? do
    let(:expression) { ->(*) { bool? } }

    describe 'success' do
      let(:output) { true }

      describe true do
        it_behaves_like 'predicate'
      end

      describe false do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe :symbol do
        it_behaves_like 'predicate'
      end

      describe 5 do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :date? do
    let(:expression) { ->(*) { date? } }

    describe 'success' do
      let(:output) { true }

      describe Date.new do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe :symbol do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :date_time? do
    let(:expression) { ->(*) { date_time? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { DateTime.new }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { :symbol }
      end
    end
  end

  describe :time? do
    let(:expression) { ->(*) { time? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { Time.new }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { :symbol }
      end
    end
  end

  describe :number? do
    let(:expression) { ->(*) { number? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { -4 }
      end

      it_behaves_like 'predicate' do
        let(:input) { 10.0 }
      end

      it_behaves_like 'predicate' do
        let(:input) { 10 }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { 'A-4' }
      end

      it_behaves_like 'predicate' do
        let(:input) { 'A10' }
      end

      it_behaves_like 'predicate' do
        let(:input) { nil }
      end

      it_behaves_like 'predicate' do
        let(:input) { :nope }
      end
    end
  end

  describe :int? do
    let(:expression) { ->(*) { int? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { 10 }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { 10.0 }
      end
    end
  end

  describe :float? do
    let(:expression) { ->(*) { float? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { 1.0 }
      end
    end

    describe 'success' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { 1 }
      end
    end
  end

  describe :decimal? do
    let(:expression) { ->(*) { decimal? } }

    describe 'success' do
      let(:output) { true }

      it_behaves_like 'predicate' do
        let(:input) { BigDecimal(1) }
      end
    end

    describe 'failure' do
      let(:output) { false }

      it_behaves_like 'predicate' do
        let(:input) { 10 }
      end
    end
  end

  describe :str? do
    let(:expression) { ->(*) { str? } }

    describe 'success' do
      let(:output) { true }

      describe String do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe Array do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :hash? do
    let(:expression) { ->(*) { hash? } }

    describe 'success' do
      let(:output) { true }

      describe Hash do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe Array do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :array? do
    let(:expression) { ->(*) { array? } }

    describe 'success' do
      let(:output) { true }

      describe Array do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe Hash do
        it_behaves_like 'predicate' do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :even? do
    let(:expression) { ->(*) { even? } }

    describe 'success' do
      let(:output) { true }

      describe 10 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 5 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :odd? do
    let(:expression) { ->(*) { odd? } }

    describe 'success' do
      let(:output) { true }

      describe 5 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 10 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :lt? do
    let(:expression) { ->(*) { lt?(10) } }

    describe 'success' do
      let(:output) { true }

      describe 5 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 200 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :gt? do
    let(:expression) { ->(*) { gt?(10) } }

    describe 'failure' do
      let(:output) { false }
      describe 5 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'success' do
      let(:output) { true }

      describe 200 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :gteq? do
    let(:expression) { ->(*) { gteq?(10) } }

    describe 'success' do
      let(:output) { true }

      describe 10 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end

      describe 11 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 9 do
        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :lteq? do
    let(:expression) { ->(*) { lteq?(10) } }

    describe 'success' do
      let(:output) { true }

      describe 9 do
        it_behaves_like 'predicate'
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 11 do
        it_behaves_like 'predicate'
      end
    end
  end

  describe :size? do
    describe 'success' do
      let(:output) { true }

      describe 'Integer' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?(2) } }
          let(:input) { [1, 2] }
        end
      end

      describe 'Range' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?(1..3) } }
          let(:input) { [1, 2] }
        end
      end

      describe 'Array' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?([3]) } }
          let(:input) { [1, 2, 3] }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 'Integer' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?(2) } }
          let(:input) { [1] }
        end
      end

      describe 'Range' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?(1..3) } }
          let(:input) { [1, 2, 3, 4] }
        end
      end

      describe 'Array' do
        it_behaves_like 'predicate' do
          let(:expression) { ->(*) { size?([3]) } }
          let(:input) { [1, 2] }
        end
      end
    end
  end

  describe :min_size? do
    let(:expression) { ->(*) { min_size?(2) } }

    describe 'success' do
      describe [1, 2, 3] do
        let(:output) { true }

        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      describe [1] do
        let(:output) { false }

        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :max_size? do
    let(:expression) { ->(*) { max_size?(2) } }

    describe 'success' do
      describe [1] do
        let(:output) { true }

        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end

    describe 'failure' do
      describe [1, 2, 3] do
        let(:output) { false }

        it_behaves_like 'predicate' do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :bytesize? do
    describe 'success' do
      let(:output) { true }

      describe 'Integer' do
        let(:expression) { ->(*) { bytesize?(1) } }

        it_behaves_like 'predicate' do
          let(:input) { 'A' }
        end
      end

      describe 'Range' do
        let(:expression) { ->(*) { bytesize?(2..3) } }

        it_behaves_like 'predicate' do
          let(:input) { 'AB' }
        end
      end

      describe 'Array' do
        let(:expression) { ->(*) { bytesize?([2, 3]) } }

        it_behaves_like 'predicate' do
          let(:input) { 'AB' }
        end
      end
    end

    describe 'failure' do
      let(:output) { false }

      describe 'Integer' do
        let(:expression) { ->(*) { bytesize?(1) } }

        it_behaves_like 'predicate' do
          let(:input) { 'AB' }
        end
      end

      describe 'Range' do
        let(:expression) { ->(*) { bytesize?(2..3) } }

        it_behaves_like 'predicate' do
          let(:input) { 'A' }
        end
      end

      describe 'Array' do
        let(:expression) { ->(*) { bytesize?([2, 3]) } }

        it_behaves_like 'predicate' do
          let(:input) { 'A' }
        end
      end
    end
  end

  describe :min_bytesize? do
    let(:expression) { ->(*) { min_bytesize?(1) } }

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { 'A' }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { '' }
      end
    end
  end

  describe :max_bytesize? do
    let(:expression) { ->(*) { max_bytesize?(1) } }

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { 'AB' }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { '' }
      end
    end
  end

  describe :included_in? do
    let(:expression) { ->(*) { included_in?([1, 2, 3]) } }

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { 1 }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { 4 }
      end
    end
  end

  describe :excluded_from? do
    let(:expression) { ->(*) { excluded_from?([1, 2, 3]) } }

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { 1 }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { 4 }
      end
    end
  end

  describe :includes? do
    let(:expression) { ->(*) { includes?(1) } }

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { [1, 2, 3] }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { [2, 3, 4] }
      end
    end
  end

  # Inverse of includes?
  # Works on all values responding to #include?
  describe :excludes? do
    describe Array do
      let(:expression) { ->(*) { excludes?(1) } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { described_class.new([1, 2, 3]) }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { described_class.new([2, 3, 4]) }
        end
      end
    end

    describe String do
      let(:expression) { ->(*) { excludes?('A') } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { described_class.new('B') }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { described_class.new('A') }
        end
      end
    end
  end

  # Regular ==
  describe 'compare methods' do
    describe :eql? do
      let(:expression) { ->(*) { eql?(10) } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 10 }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { 20 }
        end
      end
    end

    describe :not_eql? do
      let(:expression) { ->(*) { not_eql?(10) } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { 10 }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 20 }
        end
      end
    end
  end

  # equal? compare
  describe :is? do
    describe 'success' do
      it_behaves_like 'predicate' do
        let(:expression) { ->(*) { is?(nil) } }
        let(:output) { true }
        let(:input) { nil }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:expression) { ->(*) { is?(Class.new) } }
        let(:output) { false }
        let(:input) { Class.new }
      end
    end
  end

  describe 'true? & false?' do
    describe :true? do
      let(:expression) { ->(*) { true? } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { true }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { false }
        end
      end
    end

    describe :false? do
      let(:expression) { ->(*) { false? } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { false }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { true }
        end
      end
    end
  end

  # Is value part of a set?
  # case?([1,2]).call([1,2])
  # [1,2] == [1,2]
  describe :case? do
    describe 'Range' do
      let(:expression) { ->(*) { case?(5..10) } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 6 }
        end
      end
    end

    describe 'Fixnum' do
      let(:expression) { ->(*) { case?(Integer) } }

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 10 }
        end
      end
    end
  end

  describe 'uuid' do
    describe :uuid_v2?
    describe :uuid_v3?
    describe :uuid_v5?

    describe :uuid_v1? do
      let(:expression) do
        ->(*) { uuid_v1? }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { '554ef240-5433-11eb-ae93-0242ac130002' }
        end
      end
    end

    describe :uuid_v4? do
      let(:expression) do
        ->(*) { uuid_v4? }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'f2711f00-5602-45c7-ae01-c94d285592c3' }
        end
      end
    end
  end

  describe :uri? do
    describe :http do
      let(:expression) do
        ->(*) { uri?(:http) }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'http://google.com' }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { 'https://google.com' }
        end
      end
    end

    describe [:http, :https] do
      let(:expression) do
        ->(*) { uri?(%w[http https]) }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'https://google.com' }
        end

        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'http://google.com' }
        end
      end
    end

    describe Regexp do
      let(:expression) do
        ->(*) { uri?(/https?/) }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'https://google.com' }
        end

        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'http://google.com' }
        end
      end
    end

    describe :https do
      let(:expression) do
        ->(*) { uri?(:https) }
      end

      describe 'success' do
        it_behaves_like 'predicate' do
          let(:output) { true }
          let(:input) { 'https://google.com' }
        end
      end

      describe 'failure' do
        it_behaves_like 'predicate' do
          let(:output) { false }
          let(:input) { 'http://google.com' }
        end
      end
    end
  end

  describe :respond_to? do
    let(:expression) do
      ->(*) { respond_to?(:awesome?) }
    end

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:output) { true }
        let(:input) { Struct.new(:awesome?).new(true) }
      end
    end

    describe 'failure' do
      it_behaves_like 'predicate' do
        let(:output) { false }
        let(:input) { Struct.new(:not_awesome?).new(true) }
      end
    end
  end

  # Defines a custom predicate
  # Return true for :success?, false for not
  describe :predicate do
    before(:each) do
      Build.call do
        predicate :divisible_with? do |num, input|
          (input % num).zero?
        end
      end
    end

    let(:expression) do
      lambda do |*|
        divisible_with?(10)
      end
    end

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:input) { 10 }
        let(:output) { true }
      end
    end

    describe 'success' do
      it_behaves_like 'predicate' do
        let(:input) { 3 }
        let(:output) { false }
      end
    end
  end
end

describe 'operations' do
  # Run pred in block against keys in input
  describe :check do
    describe 'one path' do
      let(:expression) do
        lambda do |*|
          check keys: [:age] do
            gt?(50)
          end
        end
      end

      describe 'success' do
        it_behaves_like 'operation' do
          let(:input) { { age: 100 } }
          let(:output) { true }
        end
      end

      describe 'failure' do
        it_behaves_like 'operation' do
          let(:input) { { age: 10 } }
          let(:output) { false }
        end
      end
    end

    describe 'two paths' do
      let(:expression) do
        lambda do |*|
          check keys: %i[speed limit] do
            gt?
          end
        end
      end

      describe 'success' do
        it_behaves_like 'operation' do
          let(:input) { { speed: 50, limit: 100 } }
          let(:output) { true }
        end
      end

      describe 'failure' do
        it_behaves_like 'operation' do
          let(:input) { { speed: 100, limit: 50 } }
          let(:output) { false }
        end
      end
    end
  end

  describe :implication do
    let(:expression) do
      lambda do |*|
        implication { [gt?(0), lt?(10)] }
      end
    end

    describe '[true => true]' do
      it_behaves_like 'operation' do
        let(:input) { 5 }
        let(:output) { true }
      end
    end

    describe '[true => false]' do
      it_behaves_like 'operation' do
        let(:input) { 20 }
        let(:output) { false }
      end
    end

    describe '[false => true]' do
      it_behaves_like 'operation' do
        let(:input) { -5 }
        let(:output) { true }
      end
    end
  end

  describe :key do
    let(:expression) do
      lambda do |*|
        key name: %i[user age] do
          gt?(10)
        end
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { { user: { age: 20 } } }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { { user: { age: 5 } } }
        let(:output) { false }
      end
    end
  end

  describe :and do
    let(:expression) do
      lambda do |*|
        even?.and(int?)
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 2 }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { 5 }
        let(:output) { false }
      end
    end
  end

  describe :or do
    let(:expression) do
      lambda do |*|
        even?.or(odd?)
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 10 }
        let(:output) { true }
      end

      it_behaves_like 'operation' do
        let(:input) { 9 }
        let(:output) { true }
      end
    end
  end

  describe :negation do
    let(:expression) do
      lambda do |*|
        negation { even? }
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 9 }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { 6 }
        let(:output) { false }
      end
    end
  end

  describe :set do
    let(:expression) do
      lambda do |*|
        set { [lt?(5), gt?(2)] }
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 3 }
        let(:output) { true }
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 7 }
        let(:output) { false }
      end
    end
  end

  # All values has to pass the pred
  describe :each do
    let(:expression) do
      lambda do |*|
        each { gt?(10) }
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { [20, 30] }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { [10, 20, 30] }
        let(:output) { false }
      end
    end
  end

  describe :xor do
    let(:expression) do
      lambda do |*|
        even?.xor(gt?(4))
      end
    end

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { 5 }
        let(:output) { true }
      end

      it_behaves_like 'operation' do
        let(:input) { 2 }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { 6 }
        let(:output) { false }
      end
    end
  end

  describe :attr do
    let(:expression) do
      lambda do |*|
        attr name: :age do
          gt?(50)
        end
      end
    end

    let(:person) { Struct.new(:age) }

    describe 'success' do
      it_behaves_like 'operation' do
        let(:input) { person.new(100) }
        let(:output) { true }
      end
    end

    describe 'failure' do
      it_behaves_like 'operation' do
        let(:input) { person.new(0) }
        let(:output) { false }
      end
    end
  end

  describe 'operators' do
    describe :& do
      let(:expression) do
        lambda do |*|
          even? & int?
        end
      end

      describe 'success' do
        it_behaves_like 'operation' do
          let(:input) { 2 }
          let(:output) { true }
        end
      end

      describe 'failure' do
        it_behaves_like 'operation' do
          let(:input) { 5 }
          let(:output) { false }
        end
      end
    end

    describe :^ do
      let(:expression) do
        lambda do |*|
          even? ^ gt?(4)
        end
      end

      describe 'success' do
        it_behaves_like 'operation' do
          let(:input) { 5 }
          let(:output) { true }
        end

        it_behaves_like 'operation' do
          let(:input) { 2 }
          let(:output) { true }
        end
      end

      describe 'failure' do
        it_behaves_like 'operation' do
          let(:input) { 6 }
          let(:output) { false }
        end
      end
    end

    describe :> do
      let(:expression) do
        lambda do |*|
          gt?(0) > lt?(10)
        end
      end

      describe '[true => true]' do
        it_behaves_like 'operation' do
          let(:input) { 5 }
          let(:output) { true }
        end
      end

      describe '[true => false]' do
        it_behaves_like 'operation' do
          let(:input) { 20 }
          let(:output) { false }
        end
      end

      describe '[false => true]' do
        it_behaves_like 'operation' do
          let(:input) { -5 }
          let(:output) { true }
        end
      end
    end

    describe :then do
      let(:expression) do
        lambda do |*|
          gt?(0).then(lt?(10))
        end
      end

      describe '[true => true]' do
        it_behaves_like 'operation' do
          let(:input) { 5 }
          let(:output) { true }
        end
      end

      describe '[true => false]' do
        it_behaves_like 'operation' do
          let(:input) { 20 }
          let(:output) { false }
        end
      end

      describe '[false => true]' do
        it_behaves_like 'operation' do
          let(:input) { -5 }
          let(:output) { true }
        end
      end
    end

    describe :| do
      let(:expression) do
        lambda do |*|
          even? | odd?
        end
      end

      describe 'success' do
        it_behaves_like 'operation' do
          let(:input) { 10 }
          let(:output) { true }
        end

        it_behaves_like 'operation' do
          let(:input) { 9 }
          let(:output) { true }
        end
      end
    end
  end
end
```
