require 'dry/logic/evaluator'

module Dry
  module Logic
    module Operations
      class Key < Abstract
        attr_reader :predicate

        attr_reader :evaluator

        attr_reader :path

        attr_reader :name

        def self.new(rules, options)
          if options[:evaluator]
            super
          else
            name = options.fetch(:name)
            eval = options.fetch(:evaluator, evaluator(name))
            super(rules, options.merge(evaluator: eval, name: name, path: name))
          end
        end

        def self.evaluator(name)
          Evaluator::Key.new(name)
        end

        def initialize(*rules, **options)
          super
          @evaluator = options[:evaluator]
          @predicate = rules.first
          @name = options[:name]
          @path = options[:path]
        end

        def type
          :key
        end

        def call(hash)
          applied = predicate.(evaluator[hash])
          self.class.new(applied, options.merge(result: applied.success?))
        end

        def to_ast
          if applied?
            [success? ? :success : :failure, [name, [:path, [path, predicate.predicate_ast]]]]
          end
        end
      end
    end
  end
end
