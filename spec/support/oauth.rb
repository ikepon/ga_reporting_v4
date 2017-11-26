require 'oauth2'

module Support
  module OAuth
    def token
      # fill me in if you add more tests here, use the rake task oauth:token.
      'ya29.GlwQBcArlhrjcPPxEYjVy7xRd6JSrr-Fkff_msL0vNPuheZ9WKLg1T9Bz605aDDoHN4RhN60tESTkw44TH3AoGb6uVsw60Rv3E3hmsR8FwHaif3YUrCBOAZb92DT7A'
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
