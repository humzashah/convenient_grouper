require "active_record"
require "convenient_grouper/hash_converter"
require "convenient_grouper/version"

module ConvenientGrouper
  module_function

  def preliminaries(hash_arg, opts)
    hc = get_hash_converter(hash_arg, opts)

    {
      groups: get_groups(hc, hash_arg),
      restrictions: get_restrictions(hc)
    }
  end

  private
  module_function

  def get_hash_converter(hash_arg, opts)
    return unless hash_arg.is_a?(Hash)
    ConvenientGrouper::HashConverter.new(hash_arg, opts)
  end

  def get_groups(hc, hash_arg)
    hc.try(:groups) || hash_arg
  end

  def get_restrictions(hc)
    hc.try(:restrictions) || ""
  end
end

ActiveRecord::Relation.class_eval do
  define_method :group do |hash_arg, opts={}|
    if hash_arg.is_a?(Hash)
      hash = ConvenientGrouper.preliminaries(hash_arg, opts)
      groups = hash[:groups]
      restrictions = hash[:restrictions]
      super(groups).where(restrictions)
    else
      super(hash_arg)
    end
  end
end
