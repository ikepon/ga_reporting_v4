require 'oauth2'

module Support
  module OAuth
    def token
      # fill me in if you add more tests here, use the rake task oauth:token.
      'ya29.GlvWBu2TXbHREyY6R2Q0mmhvGAVTs2n3crKx52gRjqZOM9lgAAapqXcc5swA3AwQxpSbSuV9ss0Fjyu9hwRQCf5q099fcvL00Q3SlLH-8xk9Tq9B89wL5XtE8Ui8'
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
