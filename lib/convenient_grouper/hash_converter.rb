require_relative "custom_error"

module ConvenientGrouper
  class HashConverter
    attr_reader :groups, :restrictions

    DEFAULT_GROUP = 'others'

    def initialize(hash_arg, restrict: false)
      @hash = hash_arg
      @restrict = restrict

      validate_hash
      create_groups
      create_restrictions
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

    def create_groups
      @groups = "CASE #{[*cases, default_group].compact.join(' ')} END"
    end

    def create_restrictions
      @restrictions =
        if @restrict
          parse_hash do |column, _, value|
            "(#{column} #{lookup_str(value)})"
          end.join(' OR ')
        end || ""
    end

    def cases
      parse_hash do |column, group, value|
        "WHEN (#{column} #{lookup_str(value)}) THEN '#{group}'"
      end
    end

    def parse_hash
      @hash.each_with_object([]) do |(column, values_hash), array|
        values_hash.each do |group, value|
          array << yield(column, group, value) if group
        end
      end
    end

    def default_group
      hash = @hash.values.first
      group = hash[nil] || DEFAULT_GROUP
      "ELSE '#{group}'"
    end

    def lookup_str(value)
      case value
      when Range
        range_str(value)
      when Array
        array_str(value)
      when Numeric, String
        value_str(value)
      when NilClass
        'IS NULL'
      else
        raise_error("Unsupported type #{value.class.name} for #{value}.")
      end
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
      "IN (#{mapped})"
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
