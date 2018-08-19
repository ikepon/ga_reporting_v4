require 'hisui/version'

require 'hisui/user'
require 'hisui/model'
require 'hisui/request'
require 'hisui/response'
require 'hisui/response/ga_data'
require 'hisui/filters_expression'

require 'hisui/management/base'
require 'hisui/management/account'
require 'hisui/management/account_summary'
require 'hisui/management/goal'
require 'hisui/management/profile'
require 'hisui/management/segment'
require 'hisui/management/web_property'

module Hisui
  class << self
    def from_ga_string(str)
      str.gsub(/ga:|mcf:|rt:/, '')
    end

    def to_ga_string(str, tracking_scope = "ga")
      "#{$1}#{tracking_scope}:#{$2}" if str.to_s.camelize(:lower) =~ /^(-)?(.*)$/
    end
  end
end
