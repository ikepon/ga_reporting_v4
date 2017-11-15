module GaReportingV4
  module Management
    class WebProperty
      extend Finder

      GA_ATTRIBUTES = {
        :id => 'id',
        :name => 'name',
        :account_id => 'accountId',
        :website_url => 'websiteUrl'
      }

      attr_accessor *GA_ATTRIBUTES.keys
      attr_accessor :attributes, :user, :profiles

      def initialize(attributes, user, profiles = nil)
        GA_ATTRIBUTES.each do |key,string_key|
          self.send("#{key}=", attributes.delete(string_key) || attributes.delete(key))
        end

        @attributes = attributes
        @user = user
        @profiles = profiles
      end

      class << self
        def default_path
          '/accounts/~all/webproperties'
        end

        def build_from_summary(attributes, user)
          summary_profiles = attributes[:profiles].inject([]) { |summary_profiles, profile|
            profile[:webPropertyId] = attributes[:id]
            summary_profiles << Profile.build_from_summary(profile, user)
          }

          new(attributes, user, summary_profiles)
        end

        def for_account(account)
          all(account.user, account.path + '/webproperties')
        end

        def from_child(child)
          path = new({ id: child.web_property_id, account_id: child.account_id }, nil).path

          get(child.user, path)
        end
      end

      def path
        "/accounts/#{account_id}/webproperties/#{id}"
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end

      def account
        Account.from_child(self)
      end
    end
  end
end
