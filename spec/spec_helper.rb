ENV['RAILS_ENV'] ||= 'test'

require 'rails/all'
require 'rspec/rails'
require 'ga_reporting_v4'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

RSpec.configure do |config|
end
