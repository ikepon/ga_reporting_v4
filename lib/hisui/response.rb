module Hisui
  class Response
    def initialize(response)
      @ga_data = GaData.new(response)
    end

    def raw_attributes
      warn "[DEPRECATION] `raw_attributes` is deprecated. Please use `primary` instead."
      primary
    end

    def primary
      @primary ||= @ga_data.construct(:first)
    end

    def comparing
      @comparing ||= @ga_data.construct(:second)
    end

    def rows
      @rows ||= @ga_data.rows
    end

    def total_values
      warn "[DEPRECATION] `total_values` is deprecated. Please use `primary_total` instead."
      primary_total
    end

    def primary_total
      @primary_total ||= @ga_data.sum(:first)
    end

    def comparing_total
      @comparing_total ||= @ga_data.sum(:second)
    end

    def data?
      @ga_data.data?
    end
  end
end
