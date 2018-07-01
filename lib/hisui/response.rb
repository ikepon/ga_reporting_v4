module Hisui
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def raw_attributes
      warn "[DEPRECATION] `raw_attributes` is deprecated. Please use `primary` instead."
      primary
    end

    def primary
      @primary ||= begin
        primary = []

        data.try(:rows).try(:each) do |row|
          row_data = []
          row.dimensions.each do |dimension|
            row_data << dimension
          end

          row.metrics.first.values.each do |value|
            row_data << value
          end

          primary << Hash[fields.zip(row_data)]
        end

        primary.map { |attributes| OpenStruct.new(attributes) }
      end
    end

    def comparing
      @comparing ||= begin
        comparing = []

        data.try(:rows).try(:each) do |row|
          row_data = []
          row.dimensions.each do |dimension|
            row_data << dimension
          end

          row.try(:metrics).try(:second).try(:values).try(:each) do |value|
            row_data << value
          end

          comparing << Hash[fields.zip(row_data)]
        end

        comparing.map { |attributes| OpenStruct.new(attributes) }
      end
    end

    def rows
      @rows ||= begin
        rows = []

        data.try(:rows).try(:each) do |row|
          dimension_values = row.dimensions
          primary_data = []
          comparing_data = []

          row.metrics.first.values.each do |value|
            primary_data << value
          end

          if row.metrics.second
            row.metrics.second.values.each do |value|
              comparing_data << value
            end
          end

          rows << {
            dimensions: OpenStruct.new(Hash[dimensions.zip(dimension_values)]),
            primary: OpenStruct.new(Hash[metrics.zip(primary_data)]),
            comparing: OpenStruct.new(Hash[metrics.zip(comparing_data)]) }
        end

        rows.map { |attributes| OpenStruct.new(attributes) }
      end
    end

    def total_values
      warn "[DEPRECATION] `total_values` is deprecated. Please use `primary_total` instead."
      primary_total
    end

    def primary_total
      @primary_total ||= OpenStruct.new(Hash[metrics.zip(data.totals.first.values)])
    end

    def comparing_total
      @comparing_total ||= OpenStruct.new(Hash[metrics.zip(data.totals.try(:second).try(:values) || [])])
    end

    def data?
      data.row_count.to_i > 0
    end

    private

    def column_header
      @column_header ||= response.reports.first.column_header
    end

    def dimensions
      @dimensions ||= begin
        column_header.dimensions.each_with_object([]) do |dimension, arr|
          arr << Hisui.from_ga_string(dimension)
        end
      end
    end

    def metrics
      @metrics ||= begin
        column_header.metric_header.metric_header_entries.each_with_object([]) do |metric, arr|
          arr << Hisui.from_ga_string(metric.name)
        end
      end
    end

    def fields
      @fields ||= begin
        fields = []

        column_header.dimensions.each do |dimension|
          fields << Hisui.from_ga_string(dimension)
        end

        column_header.metric_header.metric_header_entries.each do |metric|
          fields << Hisui.from_ga_string(metric.name)
        end

        fields
      end
    end

    def data
      @data ||= response.reports.first.data
    end
  end
end
