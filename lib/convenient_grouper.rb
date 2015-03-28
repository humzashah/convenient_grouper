require "convenient_grouper/version"

require "active_record"
require_relative "convenient_grouper/hash_converter"

ActiveRecord::Relation.class_eval do
  def group(hash_arg)
    group_by =
      if hash_arg.is_a?(Hash)
        begin
          ConvenientGrouper::HashConverter.new(hash_arg).grouper
        rescue ConvenientGrouper::CustomError => e
          puts "ConvenientGrouper: #{e.message}"
        end
      end || hash_arg


    super(group_by)
  end
end
