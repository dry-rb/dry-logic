module Dry
  module Logic
    class Rule
      module Arity0
        def initialize(*)
          super

          case @args.size
          when 0
            @fn = predicate
          when 1
            arg = @args[0]
            @fn = -> { @predicate[arg] }
          else
            @fn = -> { @predicate[*@args] }
          end
        end

        def call
          if @fn[]
            Result::SUCCESS
          else
            Result.new(false, id) { ast }
          end
        end

        def []
          @fn.()
        end
      end
    end
  end
end
