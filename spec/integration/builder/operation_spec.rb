# frozen_string_literal: true

require_relative "../../shared/operation"

RSpec.describe "operations" do
  describe "nested" do
    let(:predicate) do
      Dry::Logic::Builder.call do
        check keys: [:person] do
          check keys: [:age] do
            gt?(50) & lt?(200)
          end
        end
      end
    end

    describe "success" do
      subject { predicate.call({person: {age: 100}}) }
      it { is_expected.to be_a_success }
    end

    describe "failure" do
      subject { predicate.call({person: {age: 10}}) }
      it { is_expected.not_to be_a_success }
    end
  end

  describe :check do
    describe "one path" do
      let(:expression) do
        lambda do |*|
          check keys: [:age] do
            gt?(50)
          end
        end
      end

      describe "success" do
        it_behaves_like "operation" do
          let(:input) { {age: 100} }
          let(:output) { true }
        end
      end

      describe "failure" do
        it_behaves_like "operation" do
          let(:input) { {age: 10} }
          let(:output) { false }
        end
      end
    end

    describe "two paths" do
      let(:expression) do
        lambda do |*|
          check keys: %i[speed limit] do
            gt?
          end
        end
      end

      describe "success" do
        it_behaves_like "operation" do
          let(:input) { {speed: 50, limit: 100} }
          let(:output) { true }
        end
      end

      describe "failure" do
        it_behaves_like "operation" do
          let(:input) { {speed: 100, limit: 50} }
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

    describe "[true => true]" do
      it_behaves_like "operation" do
        let(:input) { 5 }
        let(:output) { true }
      end
    end

    describe "[true => false]" do
      it_behaves_like "operation" do
        let(:input) { 20 }
        let(:output) { false }
      end
    end

    describe "[false => true]" do
      it_behaves_like "operation" do
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { {user: {age: 20}} }
        let(:output) { true }
      end
    end

    describe "failure" do
      it_behaves_like "operation" do
        let(:input) { {user: {age: 5}} }
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 2 }
        let(:output) { true }
      end
    end

    describe "failure" do
      it_behaves_like "operation" do
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 10 }
        let(:output) { true }
      end

      it_behaves_like "operation" do
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 9 }
        let(:output) { true }
      end
    end

    describe "failure" do
      it_behaves_like "operation" do
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 3 }
        let(:output) { true }
      end
    end

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 7 }
        let(:output) { false }
      end
    end
  end

  describe :each do
    let(:expression) do
      lambda do |*|
        each { gt?(10) }
      end
    end

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { [20, 30] }
        let(:output) { true }
      end
    end

    describe "failure" do
      it_behaves_like "operation" do
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

    describe "success" do
      it_behaves_like "operation" do
        let(:input) { 5 }
        let(:output) { true }
      end

      it_behaves_like "operation" do
        let(:input) { 2 }
        let(:output) { true }
      end
    end

    describe "failure" do
      it_behaves_like "operation" do
        let(:input) { 6 }
        let(:output) { false }
      end
    end
  end

  # describe :attr do
  #   let(:expression) do
  #     lambda do |*|
  #       attr name: :age do
  #         gt?(50)
  #       end
  #     end
  #   end
  #
  #   let(:person) { Struct.new(:age) }
  #
  #   describe "success" do
  #     it_behaves_like "operation" do
  #       let(:input) { person.new(100) }
  #       let(:output) { true }
  #     end
  #   end
  #
  #   describe "failure" do
  #     it_behaves_like "operation" do
  #       let(:input) { person.new(0) }
  #       let(:output) { false }
  #     end
  #   end
  # end

  describe "operators" do
    describe :& do
      let(:expression) do
        lambda do |*|
          even? & int?
        end
      end

      describe "success" do
        it_behaves_like "operation" do
          let(:input) { 2 }
          let(:output) { true }
        end
      end

      describe "failure" do
        it_behaves_like "operation" do
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

      describe "success" do
        it_behaves_like "operation" do
          let(:input) { 5 }
          let(:output) { true }
        end

        it_behaves_like "operation" do
          let(:input) { 2 }
          let(:output) { true }
        end
      end

      describe "failure" do
        it_behaves_like "operation" do
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

      describe "[true => true]" do
        it_behaves_like "operation" do
          let(:input) { 5 }
          let(:output) { true }
        end
      end

      describe "[true => false]" do
        it_behaves_like "operation" do
          let(:input) { 20 }
          let(:output) { false }
        end
      end

      describe "[false => true]" do
        it_behaves_like "operation" do
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

      describe "[true => true]" do
        it_behaves_like "operation" do
          let(:input) { 5 }
          let(:output) { true }
        end
      end

      describe "[true => false]" do
        it_behaves_like "operation" do
          let(:input) { 20 }
          let(:output) { false }
        end
      end

      describe "[false => true]" do
        it_behaves_like "operation" do
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

      describe "success" do
        it_behaves_like "operation" do
          let(:input) { 10 }
          let(:output) { true }
        end

        it_behaves_like "operation" do
          let(:input) { 9 }
          let(:output) { true }
        end
      end
    end
  end
end
