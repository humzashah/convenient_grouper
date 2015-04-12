module ConvenientGrouper
  module Regex

    module Expression
      COMPARISON = /^[<, >]={0,1}\s.+$/ # e.g. '> 1' and '<= 4'
      INEQUALITY = /!=.+/ # e.g. "!= 4" and "!= 'one'"
      NOT_NULL = /^IS NOT NULL$/i
    end

    ALL_EXPRESSIONS = Expression.constants.map { |symbol| Expression.const_get(symbol) }

    module_function
    def matches?(value)
      value.is_a?(String) &&
      ALL_EXPRESSIONS.any? do |expression|
        expression.match(value.strip)
      end
    end
  end
end
