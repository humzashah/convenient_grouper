module ConvenientGrouper
  module Regex
    COMPARISON = /^[<, >]={0,1}\s.+$/ # e.g. '> 1' and '<= 4'
    INEQUALITY = /!=.+/ # e.g. "!= 4" and "!= 'one'"

    module_function
    def matcher
      lambda do |x|
        [
          COMPARISON,
          INEQUALITY
        ].any? do |expression|
          expression.match(x.to_s.strip)
        end
      end
    end
  end
end
