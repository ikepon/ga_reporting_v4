require 'oauth2'

module Support
  module OAuth
    def token
      # fill me in if you add more tests here, use the rake task oauth:token.
      'ya29.GlwTBazXr_t1JllyKI11RxyT8lWr9mN0MqonfR4_cgfsR5vtElvNiOh0NYvLgpdpHMKobVyL8bZya5aUU3NSjr0oOwht2I3au41z4oGE9eFhQfrBhUEbn6MjqS41KQ'
    end

    def client
      @client = OAuth2::Client.new(
        # set OAuth 2.0 client ID and client secret from Google in .env file if you add more tests here.
        ENV['GOOGLE_API_CLIENT_ID'],
        ENV['GOOGLE_API_CLIENT_SECRET'],
        authorize_url: 'https://accounts.google.com/o/oauth2/auth',
        token_url: 'https://accounts.google.com/o/oauth2/token'
      )
    end

    def access_token
      OAuth2::AccessToken.new(client, token)
    end
  end
end
