module Hisui
  module Management
    class AccountSummary < Base
      attr_accessor :user, :account

      def initialize(attributes, user)
        @account = Account.build_from_summary(attributes, user)
        @user = user
      end

      def self.default_path
        '/accountSummaries'
      end

      def path
        ''
      end

      def profiles
        account.profiles
      end

      def web_properties
        account.web_properties
      end
    end
  end
end
