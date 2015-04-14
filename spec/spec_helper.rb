$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'convenient_grouper'

RSpec.configure do |config|
  # order tests:
  config.order = "random"

  # format output:
  config.color = true
  config.formatter = :documentation
end
