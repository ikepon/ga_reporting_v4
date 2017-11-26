require 'oauth2'

module Support
  module OAuth
    def token
      # fill me in if you add more tests here, use the rake task oauth:token.
      'ya29.GlwQBcY6519GZveD0nGMoCGtAiRplSe3TMS_Yc6e9Dyw4J1uBTCYokcIwWVNNIfz8XsRbmKXv6QQAt-R8GOQzzzLmPgaI1HR_LMNrXVhXEMcH-duOzDdGRsX0_13Dg'
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
      VCR.use_cassette('support/oauth') do
        OAuth2::AccessToken.new(client, token)
      end
    end
  end
end
