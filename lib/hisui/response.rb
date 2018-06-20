module Hisui
  class Response
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def primary
      @primary ||= begin
        primary = []

        data.rows.each do |row|
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

    def compare
      @compare ||= begin
        compare = []

        data.rows.each do |row|
          row_data = []
          row.dimensions.each do |dimension|
            row_data << dimension
          end

          if row.metrics.second
            row.metrics.second.values.each do |value|
              row_data << value
            end
          end

          compare << Hash[fields.zip(row_data)]
        end

        compare.map { |attributes| OpenStruct.new(attributes) }
      end
    end

    def primary_total
      @primary_total ||= OpenStruct.new(Hash[metrics.zip(data.totals.first.values)])
    end

    def compare_total
      @compare_total ||= OpenStruct.new(Hash[metrics.zip(data.totals.try(:second).try(:values) || [])])
    end

    def data?
      data.row_count.to_i > 0
    end

    private

    def column_header
      @column_header ||= response.reports.first.column_header
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
