module Hisui
  module Management
    class Goal < Base
      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :web_property_id => 'webPropertyId',
        :profile_id => 'profileId'
      }

      attr_accessor *GA_ATTRIBUTES.keys
      attr_accessor :attributes, :user

      def initialize(attributes, user)
        GA_ATTRIBUTES.each do |key, string_key|
          self.send("#{key}=", attributes.delete(string_key) || attributes.delete(key))
        end

        @attributes = attributes
        @user = user
      end

      class << self
        def default_path
          '/accounts/~all/webproperties/~all/profiles/~all/goals'
        end

        def for_account(account)
          all(account.user, account.path + '/webproperties/~all/profiles/~all/goals')
        end

        def for_web_property(web_property)
          all(web_property.user, web_property.path + '/profiles/~all/goals')
        end

        def for_profile(profile)
          all(profile.user, profile.path + '/goals')
        end
      end

      def path
        self.class.default_path + '/' + id.to_s
      end
    end
  end
end
