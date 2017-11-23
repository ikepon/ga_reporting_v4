require 'ga_reporting_v4/version'

require 'ga_reporting_v4/user'
require 'ga_reporting_v4/model'
require 'ga_reporting_v4/request'
require 'ga_reporting_v4/response'

require 'ga_reporting_v4/management/base'
require 'ga_reporting_v4/management/account'
require 'ga_reporting_v4/management/account_summary'
require 'ga_reporting_v4/management/goal'
require 'ga_reporting_v4/management/profile'
require 'ga_reporting_v4/management/segment'
require 'ga_reporting_v4/management/web_property'

module GaReportingV4
  class << self
    def from_ga_string(str)
      str.gsub(/ga:|mcf:|rt:/, '')
    end

    def to_ga_string(str, tracking_scope = "ga")
      "#{$1}#{tracking_scope}:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
    end
  end
end
