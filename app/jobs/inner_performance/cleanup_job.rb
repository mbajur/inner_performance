# frozen_string_literal: true

module InnerPerformance
  class CleanupJob < ApplicationJob
    def perform
      InnerPerformance::Event.where('created_at >= ?', InnerPerformance.configuration.events_retention)
    end
  end
end
