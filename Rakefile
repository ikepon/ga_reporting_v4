begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'oauth2'

task default: :spec

RSpec::Core::RakeTask.new

module OAuth2Helpers
  def build_client(id, secret)
    opts = {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    }

    OAuth2::Client.new(id, secret, opts)
  end

  def auth_url(client)
    client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://localhost'
    })
  end

  extend self
end

namespace :oauth2 do
  desc 'Get a new OAuth2 Token'
  task :token do
    puts 'Get your OAuth2 id and secret from the API Console: https://code.google.com/apis/console#access'

    puts
    print 'Your OAuth2 id: '
    oauth_id = $stdin.gets.strip
    print 'Your OAuth2 secret: '
    oauth_secret = $stdin.gets.strip

    client = OAuth2Helpers.build_client(oauth_id, oauth_secret)

    puts
    puts "Opening the OAuth2 auth url: #{OAuth2Helpers.auth_url(client)} ..."
    `open "#{OAuth2Helpers.auth_url(client)}"`

    puts
    print 'OAuth2 Code (in the url): '
    code = $stdin.gets.strip

    access_token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost')

    puts
    puts "Here's your access token: "
    puts access_token.token
  end
end
