ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'rails/all'
require 'rspec/rails'
require 'webmock/rspec'
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
end

RSpec.configure do |config|
  config.include Support::OAuth

  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      VCR.use_cassette(name, options, &example)
    end
  end
end
