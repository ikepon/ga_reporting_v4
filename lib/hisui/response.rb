module Hisui
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def raw_attributes
      @raw_attributes ||= begin
        raw_attributes = []

        data.rows.each do |row|
          row_data = []
          row.dimensions.each do |dimension|
            row_data << dimension
          end

          row.metrics.first.values.each do |value|
            row_data << value
          end

          raw_attributes << Hash[fields.zip(row_data)]
        end

        raw_attributes.map { |attributes| OpenStruct.new(attributes) }
      end
    end

    def total_values
      @total_values ||= OpenStruct.new(Hash[metrics.zip(data.totals.first.values)])
    end

    def data?
      data.row_count.to_i > 0
    end

    private

    def column_header
      @column_header = response.reports.first.column_header
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
      @data = response.reports.first.data
    end
  end
end
