require_relative "custom_error"

module ConvenientGrouper
  class HashConverter
    attr_reader :grouper

    DEFAULT_GROUP = 'others'

    def initialize(hash_arg)
      @hash = hash_arg
      validate_hash
      create_grouper
    end

    private

    def validate_hash
      raise_error("Incompatible hash: #{@hash}.") unless matches_conditions?
    end

    def matches_conditions?
      @hash.is_a?(Hash) &&
      (@hash.each_key.count == 1) &&
      @hash.each_value.all? { |v| v.is_a?(Hash) }
    end

    def create_grouper
      @grouper = "CASE #{[*cases, default_group].compact.join(' ')} END"
    end

    def cases
      @hash.each_with_object([]) do |(column, values_hash), array|
        values_hash.each do |group, value|
          array << "WHEN (#{column} #{lookup_str(value)}) THEN '#{group}'" if value
        end
      end
    end

    def default_group
      group = @hash.values.first.key(nil) || DEFAULT_GROUP
      "ELSE '#{group}'"
    end

    def lookup_str(value)
      method =
        case value
        when Range
          :range_str
        when Array
          :array_str
        when Numeric, String
          :value_str
        else
          raise_error("Unsupported type #{value.class.name} for #{value}.")
        end

      send(method, value)
    end

    def range_str(range)
      validate_range(range)

      min = insert_val(range.min)
      max = insert_val(range.max)

      "BETWEEN #{min} AND #{max}"
    end

    def validate_range(range)
      min = range.min
      max = range.max

      valid = min && max && (min < max)
      raise_error("Improper range: #{range}.") unless valid
    end

    def array_str(array)
      _mapped = array.map { |v| insert_val(v) }
      mapped = _mapped.join(', ')
      "IS IN (#{mapped})"
    end

    def value_str(value)
      "= #{insert_val(value)}"
    end

    def insert_val(value)
      if value.is_a?(Numeric)
        value
      else
        "'#{value.to_s}'"
      end
    end

    def raise_error(msg)
      raise CustomError.new(msg)
    end

  end
end
