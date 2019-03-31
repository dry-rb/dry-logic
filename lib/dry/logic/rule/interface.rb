module Dry
  module Logic
    class Rule
      class Interface < Module
        def initialize(arity, curried)
          curried_args = curried.times.map { |i| "@arg#{ i }" }
          define_constructor(curried_args) unless curried_args.empty?

          if arity == -1
            define_splat_application(curried_args)
          else
            define_fixed_application(curried_args, arity - curried)
          end
        end

        def define_constructor(curried_args)
          if curried_args.size == 1
            assignment = "@arg0 = @args[0]"
          else
            assignment = "#{ curried_args.join(', ') } = @args"
          end

          module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def initialize(*)
              super

              #{ assignment }
            end
          RUBY
        end

        def define_splat_application(curried_args)
          if curried_args.empty?
            application = "@predicate[*input]"
          else
            application = "@predicate[#{ curried_args.join(', ') }, *input]"
          end

          module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def call(*input)
              if #{ application }
                Result::SUCCESS
              else
                Result.new(false, id) { ast(*input) }
              end
            end

            def [](*input)
              #{ application }
            end
          RUBY
        end

        def define_fixed_application(curried_args, unapplied)
          unapplied_args = unapplied.times.map { |i| "input#{ i }" }
          parameters = unapplied_args.join(', ')
          application = "@predicate[#{ (curried_args + unapplied_args).join(', ') }]"

          module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
            def call(#{ parameters })
              if #{ application }
                Result::SUCCESS
              else
                Result.new(false, id) { ast(#{ parameters }) }
              end
            end

            def [](#{ parameters })
              #{ application }
            end
          RUBY
        end
      end
    end
  end
end
