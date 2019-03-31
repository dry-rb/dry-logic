module Dry
  module Logic
    class Rule
      module Arity1
        def initialize(*)
          super

          case @args.size
          when 0
            @fn = predicate
          when 1
            arg = @args[0]
            @fn = -> input { @predicate[arg, input] }
          else
            @fn = -> input { @predicate[*@args, input] }
          end
        end

        def call(input)
          if @fn[input]
            Result::SUCCESS
          else
            Result.new(false, id) { ast(input) }
          end
        end

        def [](input)
          @fn[input]
        end
      end
    end
  end
end
