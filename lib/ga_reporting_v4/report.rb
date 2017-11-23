require 'google/apis/analyticsreporting_v4'

module GaReportingV4
  class Report
    attr_reader :token, :id, :start_date, :end_date, :limit

    def initialize(token:, id:, start_date:, end_date:, limit: 100)
      @token = token
      @id = id
      @start_date = start_date
      @end_date = end_date
      @limit = limit
    end

    def fetch_data
      # NOTE: order_bys で加重してbounceRateで並べ替えしたいが、bounceRateを最初に持ってこないとエラーになるのでこの順番にしてる。
      metrics_params = %i[bounce_rate sessions new_users pageviews_per_session avg_session_duration avg_time_on_page]
      dimentions_params = %i[landing_page_path]

      # NOTE: cf. https://developers.google.com/analytics/devguides/reporting/core/v4/rest/v4/reports/batchGet?hl=ja#OrderBy
      order_bys = {
        field_name: 'ga:bounceRate',
        order_type: 'SMART',
        sort_order: 'DESCENDING'
      }

      GaReportingV4::Request.fetch_ga_data(
        token: token,
        id: id,
        start_date: start_date,
        end_date: end_date,
        metrics: metrics(metrics_params),
        dimensions: dimensions(dimentions_params),
        limit: limit
      )
    end

    private

    def metrics(field = nil)
      @metrics ||= Set.new([])
      field&.each { |f| @metrics << { expression: GaReportingV4.to_ga_string(f) } }
      @metrics
    end

    def dimensions(field = nil)
      @dimensions ||= Set.new([])
      field&.each { |f| @dimensions << { name: GaReportingV4.to_ga_string(f) } }
      @dimensions
    end
  end
end
