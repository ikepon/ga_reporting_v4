require 'oauth2'

module Support
  module OAuth
    def token
      # fill me in if you add more tests here, use the rake task oauth:token.
      'ya29.GlsPBSLG9YBFXkO-l0hk1Aot1qaTNXmpoIi-CxPlcP16gfHMjQ1PyEqGnr7RY0wmmjkwNBeLbwPPfcAzc5D0Hk35NA9Rm4dbQ_0RGz8Jkb_7Sdumg9ZUhf9hF6DA'
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
