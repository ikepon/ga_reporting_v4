module Hisui
  module Model
    # Adds metrics to the class for retrieval from GA
    #
    # @param field [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all metrics
    def metrics(*field)
      @metrics ||= Set.new([])
      field.try(:each) { |f| @metrics << { expression: Hisui.to_ga_string(f) } }
      @metrics
    end

    # Adds dimensions to the class for retrieval from GA
    #
    # @param field [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all dimensions
    def dimensions(*field)
      @dimensions ||= Set.new([])
      field.try(:each) { |f| @dimensions << { name: Hisui.to_ga_string(f) } }
      @dimensions
    end

    # Adds order_bys to the class for retrieval from GA
    #
    # @param field [Hash] options:
    #   * field_name
    #   * order_type
    #   * sort_order
    #
    # cf. https://developers.google.com/analytics/devguides/reporting/core/v4/rest/v4/reports/batchGet#OrderBy
    def order_bys(field = nil)
      @order_bys ||= Set.new([])
      @order_bys << field if field
      @order_bys
    end

    # Adds filters_expression to the class for retrieval from GA
    #
    # @param field [Hash] options:
    #   * field_name
    #   * operator
    #   * value
    #
    # operators are '==', '~=' and so on. cf: https://developers.google.com/analytics/devguides/reporting/core/v3/reference?hl=ja#filters
    #
    # @return concatenated string
    def filters_expression(field = nil)
      @filters_expression ||= ''
      @filters_expression = Hisui::FiltersExpression.new(field).to_param if field
      @filters_expression
    end

    def results(profile:, **options)
      Hisui::Request.new(profile: profile, model: self, **options).fetch_data
    end
  end
end
