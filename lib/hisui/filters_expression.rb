module Hisui
  class FiltersExpression
    def initialize(field_name:, value:, operator:)
      @field_name = field_name
      @value = value
      @operator = operator
    end

    def to_param
      "#{Hisui.to_ga_string(@field_name)}#{@operator}#{@value}"
    end
  end
end
