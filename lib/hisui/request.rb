require 'google/apis/analyticsreporting_v4'

module Hisui
  class Request
    BASIC_OPTION_KEYS = [:start_date, :end_date, :compare_start_date, :compare_end_date, :limit]

    attr_accessor :profile, :model, :start_date, :end_date, :compare_start_date, :compare_end_date, :limit

    def initialize(profile:, model:, **options)
      @profile = profile
      @model = model
      @start_date = Time.current.advance(months: -1)
      @end_date = Time.current

      BASIC_OPTION_KEYS.each do |key|
        self.send("#{key}=".to_sym, options[key]) if options.try(:has_key?, key)
      end
    end

    def fetch_data
      reporting_service = Google::Apis::AnalyticsreportingV4::AnalyticsReportingService.new
      reporting_service.authorization = profile.user.access_token.token

      date_ranges = []
      date_ranges << Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: start_date.to_s, end_date: end_date.to_s)

      if compare_start_date && compare_end_date
        date_ranges << Google::Apis::AnalyticsreportingV4::DateRange.new(start_date: compare_start_date.to_s, end_date: compare_end_date.to_s)
      end

      request = Google::Apis::AnalyticsreportingV4::GetReportsRequest.new(
        report_requests: [Google::Apis::AnalyticsreportingV4::ReportRequest.new(
          view_id: profile.id,
          metrics: model.metrics,
          dimensions: model.dimensions,
          date_ranges: date_ranges,
          order_bys: model.order_bys,
          page_size: limit
        )]
      )

      response = reporting_service.batch_get_reports(request)
      Hisui::Response.new(response)
    end
  end
end
