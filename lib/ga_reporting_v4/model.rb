module GaReportingV4
  module Model
    # Adds metrics to the class for retrieval from GA
    #
    # @param fields [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all metrics
    def metrics(field = nil)
      @metrics ||= Set.new([])
      field.try(:each) { |f| @metrics << { expression: GaReportingV4.to_ga_string(f) } }
      @metrics
    end

    # Adds dimensions to the class for retrieval from GA
    #
    # @param fields [Symbol] the names of the fields to retrieve
    # @return [ListParameter] the set of all dimensions
    def dimensions(field = nil)
      @dimensions ||= Set.new([])
      field.try(:each) { |f| @dimensions << { name: GaReportingV4.to_ga_string(f) } }
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

    def results(profile:, **options)
      GaReportingV4::Request.new(profile: profile, model: self, **options).fetch_data
    end
  end
end
