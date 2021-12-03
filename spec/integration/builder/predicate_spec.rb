# frozen_string_literal: true

require_relative "../../shared/predicate"

RSpec.describe "predicates" do
  let(:input) { described_class }

  describe :key? do
    let(:expression) { ->(*) { key?(:speed) } }

    describe "success" do
      let(:output) { true }

      describe({speed: 100}) do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }

      describe({age: 50}) do
        it_behaves_like "predicate"
      end
    end
  end

  describe :format? do
    let(:expression) { ->(*) { format?(/^(A|B)$/) } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { "A" }
      end

      it_behaves_like "predicate" do
        let(:input) { "B" }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { "C" }
      end

      it_behaves_like "predicate" do
        let(:input) { "D" }
      end
    end
  end

  describe :type? do
    let(:expression) { ->(*) { type?(String) } }

    describe "success" do
      let(:output) { true }

      describe "string" do
        it_behaves_like "predicate" do
          let(:input) { "string" }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { :symbol }
      end
    end
  end

  describe :nil? do
    let(:expression) { ->(*) { nil? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { nil }
      end
    end

    describe "failure" do
      let(:output) { false }

      describe :symbol do
        it_behaves_like "predicate"
      end
    end
  end

  describe :attr? do
    let(:expression) { ->(*) { attr?(:name) } }

    describe "success" do
      let(:output) { true }

      describe Struct.new(:name).new("John") do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }

      describe Struct.new(:age).new(50) do
        it_behaves_like "predicate"
      end
    end
  end

  describe :empty? do
    let(:expression) { ->(*) { empty? } }

    describe "success" do
      let(:output) { true }

      describe({}) do
        it_behaves_like "predicate"
      end

      describe String do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end

      describe [] do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }
      describe({key: "value"}) do
        it_behaves_like "predicate"
      end

      describe "string" do
        it_behaves_like "predicate"
      end

      describe nil do
        it_behaves_like "predicate"
      end

      describe [1, 2] do
        it_behaves_like "predicate"
      end
    end
  end

  describe :filled? do
    let(:expression) { ->(*) { filled? } }

    describe "success" do
      let(:output) { true }
      describe({key: "value"}) do
        it_behaves_like "predicate"
      end

      describe "string" do
        it_behaves_like "predicate"
      end

      describe nil do
        it_behaves_like "predicate"
      end

      describe [1, 2] do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }
      describe({}) do
        it_behaves_like "predicate"
      end

      describe String do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end

      describe [] do
        it_behaves_like "predicate"
      end
    end
  end

  describe :bool? do
    let(:expression) { ->(*) { bool? } }

    describe "success" do
      let(:output) { true }

      describe true do
        it_behaves_like "predicate"
      end

      describe false do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }

      describe :symbol do
        it_behaves_like "predicate"
      end

      describe 5 do
        it_behaves_like "predicate"
      end
    end
  end

  describe :date? do
    let(:expression) { ->(*) { date? } }

    describe "success" do
      let(:output) { true }

      describe Date.new do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }

      describe :symbol do
        it_behaves_like "predicate"
      end
    end
  end

  describe :date_time? do
    let(:expression) { ->(*) { date_time? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { DateTime.new }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { :symbol }
      end
    end
  end

  describe :time? do
    let(:expression) { ->(*) { time? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { Time.new }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { :symbol }
      end
    end
  end

  describe :number? do
    let(:expression) { ->(*) { number? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { -4 }
      end

      it_behaves_like "predicate" do
        let(:input) { 10.0 }
      end

      it_behaves_like "predicate" do
        let(:input) { 10 }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { "A-4" }
      end

      it_behaves_like "predicate" do
        let(:input) { "A10" }
      end

      it_behaves_like "predicate" do
        let(:input) { nil }
      end

      it_behaves_like "predicate" do
        let(:input) { :nope }
      end
    end
  end

  describe :int? do
    let(:expression) { ->(*) { int? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { 10 }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { 10.0 }
      end
    end
  end

  describe :float? do
    let(:expression) { ->(*) { float? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { 1.0 }
      end
    end

    describe "success" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { 1 }
      end
    end
  end

  describe :decimal? do
    let(:expression) { ->(*) { decimal? } }

    describe "success" do
      let(:output) { true }

      it_behaves_like "predicate" do
        let(:input) { BigDecimal(1) }
      end
    end

    describe "failure" do
      let(:output) { false }

      it_behaves_like "predicate" do
        let(:input) { 10 }
      end
    end
  end

  describe :str? do
    let(:expression) { ->(*) { str? } }

    describe "success" do
      let(:output) { true }

      describe String do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe Array do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :hash? do
    let(:expression) { ->(*) { hash? } }

    describe "success" do
      let(:output) { true }

      describe Hash do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe Array do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :array? do
    let(:expression) { ->(*) { array? } }

    describe "success" do
      let(:output) { true }

      describe Array do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe Hash do
        it_behaves_like "predicate" do
          let(:input) { described_class.new }
        end
      end
    end
  end

  describe :even? do
    let(:expression) { ->(*) { even? } }

    describe "success" do
      let(:output) { true }

      describe 10 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe 5 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :odd? do
    let(:expression) { ->(*) { odd? } }

    describe "success" do
      let(:output) { true }

      describe 5 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe 10 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :lt? do
    let(:expression) { ->(*) { lt?(10) } }

    describe "success" do
      let(:output) { true }

      describe 5 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe 200 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :gt? do
    let(:expression) { ->(*) { gt?(10) } }

    describe "failure" do
      let(:output) { false }
      describe 5 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "success" do
      let(:output) { true }

      describe 200 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :gteq? do
    let(:expression) { ->(*) { gteq?(10) } }

    describe "success" do
      let(:output) { true }

      describe 10 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end

      describe 11 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe 9 do
        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :lteq? do
    let(:expression) { ->(*) { lteq?(10) } }

    describe "success" do
      let(:output) { true }

      describe 9 do
        it_behaves_like "predicate"
      end
    end

    describe "failure" do
      let(:output) { false }

      describe 11 do
        it_behaves_like "predicate"
      end
    end
  end

  describe :size? do
    describe "success" do
      let(:output) { true }

      describe "Integer" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?(2) } }
          let(:input) { [1, 2] }
        end
      end

      describe "Range" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?(1..3) } }
          let(:input) { [1, 2] }
        end
      end

      describe "Array" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?([3]) } }
          let(:input) { [1, 2, 3] }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe "Integer" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?(2) } }
          let(:input) { [1] }
        end
      end

      describe "Range" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?(1..3) } }
          let(:input) { [1, 2, 3, 4] }
        end
      end

      describe "Array" do
        it_behaves_like "predicate" do
          let(:expression) { ->(*) { size?([3]) } }
          let(:input) { [1, 2] }
        end
      end
    end
  end

  describe :min_size? do
    let(:expression) { ->(*) { min_size?(2) } }

    describe "success" do
      describe [1, 2, 3] do
        let(:output) { true }

        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      describe [1] do
        let(:output) { false }

        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :max_size? do
    let(:expression) { ->(*) { max_size?(2) } }

    describe "success" do
      describe [1] do
        let(:output) { true }

        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end

    describe "failure" do
      describe [1, 2, 3] do
        let(:output) { false }

        it_behaves_like "predicate" do
          let(:input) { described_class }
        end
      end
    end
  end

  describe :bytesize? do
    describe "success" do
      let(:output) { true }

      describe "Integer" do
        let(:expression) { ->(*) { bytesize?(1) } }

        it_behaves_like "predicate" do
          let(:input) { "A" }
        end
      end

      describe "Range" do
        let(:expression) { ->(*) { bytesize?(2..3) } }

        it_behaves_like "predicate" do
          let(:input) { "AB" }
        end
      end

      describe "Array" do
        let(:expression) { ->(*) { bytesize?([2, 3]) } }

        it_behaves_like "predicate" do
          let(:input) { "AB" }
        end
      end
    end

    describe "failure" do
      let(:output) { false }

      describe "Integer" do
        let(:expression) { ->(*) { bytesize?(1) } }

        it_behaves_like "predicate" do
          let(:input) { "AB" }
        end
      end

      describe "Range" do
        let(:expression) { ->(*) { bytesize?(2..3) } }

        it_behaves_like "predicate" do
          let(:input) { "A" }
        end
      end

      describe "Array" do
        let(:expression) { ->(*) { bytesize?([2, 3]) } }

        it_behaves_like "predicate" do
          let(:input) { "A" }
        end
      end
    end
  end

  describe :min_bytesize? do
    let(:expression) { ->(*) { min_bytesize?(1) } }

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { "A" }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { "" }
      end
    end
  end

  describe :max_bytesize? do
    let(:expression) { ->(*) { max_bytesize?(1) } }

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { "AB" }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { "" }
      end
    end
  end

  describe :included_in? do
    let(:expression) { ->(*) { included_in?([1, 2, 3]) } }

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { 1 }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { 4 }
      end
    end
  end

  describe :excluded_from? do
    let(:expression) { ->(*) { excluded_from?([1, 2, 3]) } }

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { 1 }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { 4 }
      end
    end
  end

  describe :includes? do
    let(:expression) { ->(*) { includes?(1) } }

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { [1, 2, 3] }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { [2, 3, 4] }
      end
    end
  end

  describe :excludes? do
    describe Array do
      let(:expression) { ->(*) { excludes?(1) } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { described_class.new([1, 2, 3]) }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { described_class.new([2, 3, 4]) }
        end
      end
    end

    describe String do
      let(:expression) { ->(*) { excludes?("A") } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { described_class.new("B") }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { described_class.new("A") }
        end
      end
    end
  end

  describe "compare methods" do
    describe :eq? do
      let(:expression) { ->(*) { eq?(10) } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { 10 }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { 20 }
        end
      end
    end

    describe :not_eq? do
      let(:expression) { ->(*) { not_eq?(10) } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { 10 }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { 20 }
        end
      end
    end
  end

  describe :is? do
    describe "success" do
      it_behaves_like "predicate" do
        let(:expression) { ->(*) { is?(nil) } }
        let(:output) { true }
        let(:input) { nil }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:expression) { ->(*) { is?(Class.new) } }
        let(:output) { false }
        let(:input) { Class.new }
      end
    end
  end

  describe "true? & false?" do
    describe :true? do
      let(:expression) { ->(*) { true? } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { true }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { false }
        end
      end
    end

    describe :false? do
      let(:expression) { ->(*) { false? } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { false }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { true }
        end
      end
    end
  end

  describe :case? do
    describe "Range" do
      let(:expression) { ->(*) { case?(5..10) } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { 6 }
        end
      end
    end

    describe "Fixnum" do
      let(:expression) { ->(*) { case?(Integer) } }

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { 10 }
        end
      end
    end
  end

  describe "uuid" do
    describe :uuid_v2?
    describe :uuid_v3?
    describe :uuid_v5?

    describe :uuid_v1? do
      let(:expression) do
        ->(*) { uuid_v1? }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "554ef240-5433-11eb-ae93-0242ac130002" }
        end
      end
    end

    describe :uuid_v4? do
      let(:expression) do
        ->(*) { uuid_v4? }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "f2711f00-5602-45c7-ae01-c94d285592c3" }
        end
      end
    end
  end

  describe :uri? do
    describe :http do
      let(:expression) do
        ->(*) { uri?(:http) }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "http://google.com" }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { "https://google.com" }
        end
      end
    end

    describe [:http, :https] do
      let(:expression) do
        ->(*) { uri?(%w[http https]) }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "https://google.com" }
        end

        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "http://google.com" }
        end
      end
    end

    describe Regexp do
      let(:expression) do
        ->(*) { uri?(/https?/) }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "https://google.com" }
        end

        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "http://google.com" }
        end
      end
    end

    describe :https do
      let(:expression) do
        ->(*) { uri?(:https) }
      end

      describe "success" do
        it_behaves_like "predicate" do
          let(:output) { true }
          let(:input) { "https://google.com" }
        end
      end

      describe "failure" do
        it_behaves_like "predicate" do
          let(:output) { false }
          let(:input) { "http://google.com" }
        end
      end
    end
  end

  describe :respond_to? do
    let(:expression) do
      ->(*) { respond_to?(:awesome?) }
    end

    describe "success" do
      it_behaves_like "predicate" do
        let(:output) { true }
        let(:input) { Struct.new(:awesome?).new(true) }
      end
    end

    describe "failure" do
      it_behaves_like "predicate" do
        let(:output) { false }
        let(:input) { Struct.new(:not_awesome?).new(true) }
      end
    end
  end

  describe :predicate do
    before { extend Dry::Logic::Builder }

    before(:each) do
      build do
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

    describe "success" do
      it_behaves_like "predicate" do
        let(:input) { 10 }
        let(:output) { true }
      end
    end

    describe "success" do
      it_behaves_like "predicate" do
        let(:input) { 3 }
        let(:output) { false }
      end
    end
  end
end
