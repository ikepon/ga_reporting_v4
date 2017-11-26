ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'vcr'
require 'dotenv/load'
require 'pry-byebug'
require 'ga_reporting_v4'

require 'support/oauth'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {:record => :all, :serialize_with => :json}
end

RSpec.configure do |config|
  config.include Support::OAuth
end
