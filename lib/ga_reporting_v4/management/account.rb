module GaReportingV4
  module Management
    class Account
      extend Finder

      attr_accessor :id, :name, :user, :web_properties

      def initialize(attributes, user, web_properties = nil)
        @id = attributes['id']
        @name = attributes['name']
        @user = user
        @web_properties = web_properties
      end

      class << self
        def default_path
          '/accounts'
        end

        def build_from_summary(attributes, user)
          web_properties_attributes = attributes[:webProperties]

          summary_properties = web_properties_attributes.inject([]) { |props, web_property_attributes|
            web_property_attributes[:accountId] = attributes[:id]
            props << WebProperty.build_from_summary(web_property_attributes, user)
          }

          Account.new(attributes, user, summary_properties)
        end

        def from_child(child)
          all(child.user).detect { |a| a.id == child.account_id }
        end
      end

      def path
        "/accounts/#{id}"
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
      end

      def profiles
        if web_properties
          web_properties.inject([]) { |profiles, prop| profiles.concat(prop.profiles) }
        else
          Profile.for_account(self)
        end
      end
    end
  end
end
