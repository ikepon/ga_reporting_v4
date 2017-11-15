module GaReportingV4
  module Management
    class WebProperty
      extend Finder

      attr_accessor :id, :name, :website_url, :user

      def initialize(attributes, user)
        @id = attributes['id']
        @name = attributes['name']
        @website_url = attributes['websiteUrl']
        @user = user
      end

      def self.default_path
        '/accounts/~all/webproperties'
      end
    end
  end
end
