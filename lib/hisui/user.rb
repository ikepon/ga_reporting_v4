module Hisui
  class User
    attr_accessor :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    # All the `Account` records available to this user
    def accounts
      Management::Account.all(self)
    end

    def account_summaries
      Management::AccountSummary.all(self)
    end

    # All the `Profile` records available to this user
    def profiles
      Management::Profile.all(self)
    end

    # All the `Segment` records available to this user
    def segments
      Management::Segment.all(self)
    end

    # All the `WebProperty` records available to this user
    def web_properties
      Management::WebProperty.all(self)
    end
  end
end
