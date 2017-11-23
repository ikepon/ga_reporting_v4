require 'google/apis/analyticsreporting_v4'

module GaReportingV4
  class Request
    class << self
      def fetch_ga_data(token:, id:, start_date:, end_date:, metrics:, dimensions:, order_bys: nil, limit: 100)
        reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
        reporting_service.authorization = token

        date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: start_date.to_s, end_date: end_date.to_s)

        request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
          report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
            view_id: id,
            metrics: metrics,
            dimensions: dimensions,
            date_ranges: [date_range],
            order_bys: [order_bys],
            page_size: limit
          )]
        )

        response = reporting_service.batch_get_reports(request)
        GaReportingV4::Response.new(response)
      end
    end
  end
end
