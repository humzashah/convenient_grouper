require_relative "error"
require_relative "regex"

module ConvenientGrouper
  class HashConverter
    attr_reader :groups, :restrictions

    module Default
      GROUP = 'others'

      OPTIONS = {
        restrict: false
      }
    end

    private

    def initialize(hash_arg, options=Default::OPTIONS)
      @hash = hash_arg
      validate_hash

      @options = options
      validate_options

      @restrict = (@options[:restrict] == true)

      create_groups
      create_restrictions
    end

    def validate_hash
      raise_error("Incompatible hash: #{@hash}.") unless matches_conditions?
    end

    def validate_options
      valid_keys = Default::OPTIONS.keys
      invalid_keys = @options.keys - valid_keys
      return if valid = invalid_keys.empty?

      valid_keys_str = valid_keys.join(', ')
      invalid_keys_str = invalid_keys.join(', ')
      raise_error "You provided invalid options: #{invalid_keys_str}. Supported options include: #{valid_keys_str}."
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
            column_value_matcher(column, value)
          end.join(' OR ')
        end || ""
    end

    def cases
      parse_hash do |column, group, value|
        "WHEN #{column_value_matcher(column, value)} THEN '#{group}'"
      end
    end

    def parse_hash
      @hash.each_with_object([]) do |(column, values_hash), array|
        values_hash.each do |group, value|
          array << yield(column, group, value) if group
        end
      end
    end

    def column_value_matcher(column, value)
      "(#{column} #{lookup_str(value)})"
    end

    def default_group
      hash = @hash.values.first
      group = hash[nil] || Default::GROUP
      "ELSE '#{group}'"
    end

    def lookup_str(value)
      case value
      when Range
        range_str(value)
      when Array
        array_str(value)
      when lambda { |x| Regex.matches?(x) }
        value
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
      mapped_str = array.map { |v| insert_val(v) }.join(', ')
      "IN (#{mapped_str})"
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
      raise Error.new(msg)
    end

  end
end
