require 'dry/logic/evaluator'

module Dry
  module Logic
    module Operations
      class Key < Abstract
        attr_reader :predicate

        attr_reader :evaluator

        attr_reader :path

        def self.new(rules, options)
          if options[:evaluator]
            super
          else
            name = options.fetch(:name)
            eval = options.fetch(:evaluator, evaluator(name))
            super(rules, options.merge(evaluator: eval, path: name))
          end
        end

        def self.evaluator(name)
          Evaluator::Key.new(name)
        end

        def initialize(*rules, **options)
          super
          @evaluator = options[:evaluator]
          @predicate = rules.first
          @path = options[:path]
        end

        def type
          :key
        end

        def call(hash)
          input = evaluator[hash]
          result = predicate.(input)
          Result.new(result.success?, path) { [type, [path, result.ast]] }
        end

        def [](hash)
          predicate[evaluator[hash]]
        end

        def ast(input = nil)
          if input
            [type, [path, predicate.ast(evaluator[input])]]
          else
            [type, [path, predicate.ast]]
          end
        end
      end
    end
  end
end
