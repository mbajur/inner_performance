# frozen_string_literal: true

module InnerPerformance
  class CleanupJob < ApplicationJob
    def perform
      InnerPerformance::Event
        .where('created_at < ?', InnerPerformance.configuration.events_retention.ago)
        .destroy_all
    end
  end
end
