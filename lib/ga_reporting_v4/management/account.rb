module GaReportingV4
  module Management
    class Account
      extend Finder

      attr_accessor :id, :name, :user

      def initialize(attributes, user)
        @id = attributes['id']
        @name = attributes['name']
        @user = user
      end

      def self.default_path
        '/accounts'
      end
    end
  end
end
