module GaReportingV4
  module Management
    class Profile
      extend Finder

      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :web_property_id => 'webPropertyId'
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
          '/accounts/~all/webproperties/~all/profiles'
        end

        def build_from_summary(attributes, user)
          Profile.new(attributes, user)
        end

        def for_account(account)
          all(account.user, account.path + '/webproperties/~all/profiles')
        end

        def for_web_property(web_property)
          all(web_property.user, web_property.path + '/profiles')
        end
      end

      def path
        "/accounts/#{account_id}/webproperties/#{web_property_id}/profiles/#{id}"
      end
    end
  end
end
