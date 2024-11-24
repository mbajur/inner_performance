# frozen_string_literal: true

module InnerPerformance
  class DashboardController < ApplicationController
    def index
      @recent_events = InnerPerformance::Event.all.order(id: :desc).limit(25)
      @average_req_duration = InnerPerformance::Events::ProcessActionActionController.all.average(:duration)
      @average_job_duration = InnerPerformance::Events::PerformActiveJob.average(:duration) || 0
      @biggest_events = \
        InnerPerformance::Event.select('SUM(duration) as duration, name, COUNT(*) as count, AVG(duration) as avg_duration')
                               .group(:name)
                               .order('duration DESC')
                               .limit(10)
    end
  end
end
