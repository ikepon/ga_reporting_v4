module Hisui
  module Management
    class Base
      class << self
        def base_uri
          'https://www.googleapis.com/analytics/v3/management'
        end

        def all(user, path = default_path)
          json = user.access_token.get(base_uri + path).body
          JSON.parse(json)['items'].map { |item| new(item.with_indifferent_access, user) }
        end
      end
    end
  end
end
