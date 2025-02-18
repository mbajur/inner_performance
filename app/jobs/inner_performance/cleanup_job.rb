# frozen_string_literal: true

module InnerPerformance
  class CleanupJob < ApplicationJob
    def perform
      InnerPerformance::Trace
        .joins(:event)
        .where("inner_performance_events.created_at < ?", InnerPerformance.configuration.events_retention.ago)
        .delete_all

      InnerPerformance::Event
        .where("created_at < ?", InnerPerformance.configuration.events_retention.ago)
        .delete_all
    end
  end
end
