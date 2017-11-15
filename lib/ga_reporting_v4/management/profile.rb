module GaReportingV4
  module Management
    class Profile
      extend Finder

      attr_accessor :id, :name, :user

      def initialize(attributes, user)
        @id = attributes['id']
        @name = attributes['name']
        @user = user
      end

      def self.default_path
        '/accounts/~all/webproperties/~all/profiles'
      end
    end
  end
end
