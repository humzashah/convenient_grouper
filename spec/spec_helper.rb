$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "bundler"
Bundler.require
require 'convenient_grouper'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end
