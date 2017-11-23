require 'google/apis/analyticsreporting_v4'

module GaReportingV4
  class Request
    BASIC_OPTION_KEYS = [:start_date, :end_date, :limit]

    attr_accessor :profile, :model, :start_date, :end_date, :limit

    def initialize(profile:, model:, **options)
      @profile = profile
      @model = model
      @start_date = Date.current - 1.month
      @end_date = Date.current

      BASIC_OPTION_KEYS.each do |key|
        self.send("#{key}=".to_sym, options[key]) if options&.has_key?(key)
      end
    end

    def fetch_data
      reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
      reporting_service.authorization = profile.user.access_token.token

      date_range = Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: start_date.to_s, end_date: end_date.to_s)

      request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
        report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
          view_id: profile.id,
          metrics: model.metrics,
          dimensions: model.dimensions,
          date_ranges: [date_range],
          order_bys: model.order_bys,
          page_size: limit
        )]
      )

      response = reporting_service.batch_get_reports(request)
      GaReportingV4::Response.new(response)
    end
  end
end
