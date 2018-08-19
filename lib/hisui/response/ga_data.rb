module Hisui
  class Response
    class GaData
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def construct(ordinal)
        row_data_struct = Struct.new(*fields)

        data.try(:rows).try(:each_with_object, []) do |row, arr|
          row_data = []
          row.dimensions.each do |dimension|
            row_data << dimension
          end

          row.try(:metrics).try(ordinal.to_sym).try(:values).try(:each) do |value|
            row_data << value
          end

          arr << row_data_struct.new(*row_data)
        end
      end

      def sum(ordinal)
        total_struct = Struct.new(*metrics)
        total_struct.new(*data.totals.try(ordinal).try(:values))
      end

      def rows
        @rows ||= begin
          data.try(:rows).try(:each_with_object, []) do |row, arr|
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

            rows_struct = Struct.new(:dimensions, :primary, :comparing)
            dimension_struct = Struct.new(*dimensions)
            metric_struct = Struct.new(*metrics)

            arr << rows_struct.new(dimension_struct.new(*dimension_values), metric_struct.new(*primary_data), metric_struct.new(*comparing_data))
          end
        end
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
            arr << Hisui.from_ga_string(dimension).to_sym
          end
        end
      end

      def metrics
        @metrics ||= begin
          column_header.metric_header.metric_header_entries.each_with_object([]) do |metric, arr|
            arr << Hisui.from_ga_string(metric.name).to_sym
          end
        end
      end

      def fields
        @fields ||= begin
          fields = []

          column_header.dimensions.each do |dimension|
            fields << Hisui.from_ga_string(dimension).to_sym
          end

          column_header.metric_header.metric_header_entries.each do |metric|
            fields << Hisui.from_ga_string(metric.name).to_sym
          end

          fields
        end
      end

      def data
        @data ||= response.reports.first.data
      end
    end
  end
end
