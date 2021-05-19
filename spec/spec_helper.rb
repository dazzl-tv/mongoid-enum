# frozen_string_literal: true

require 'mongoid'
require 'mongoid/rspec'
require 'mongoid/enum/dazzl'
require 'simplecov'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

ENV['MONGOID_ENV'] = 'test'

RSpec.configure do |config|
  config.include Mongoid::Matchers

  config.before do
    Mongoid.purge!
  end

  # Stop when rspec fail
  config.fail_fast = true

  # Exclude spec broken
  config.filter_run_excluding broken: true
end

# Load mongoid configuration
Mongoid.load!(File.expand_path('support/mongoid.yml', __dir__), :test)
Mongo::Logger.logger.level = ::Logger::INFO
