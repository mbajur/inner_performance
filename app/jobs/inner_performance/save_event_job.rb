# frozen_string_literal: true

module InnerPerformance
  class SaveEventJob < ApplicationJob
    def perform(type:, created_at:, event:, name:, duration:, db_runtime:, properties: {}, traces: [])
      event = InnerPerformance::Event.create(
        type: type,
        created_at: created_at,
        event: event,
        name: name,
        duration: duration,
        db_runtime: db_runtime,
        properties: properties,
      )

      if InnerPerformance.configuration.traces_enabled && traces.any?
        InnerPerformance::Trace.insert_all(
          traces.map do |trace|
            InnerPerformance::TraceForInsertInitializer.new(trace: trace, event: event)
          end,
        )
      end

      InnerPerformance::CleanupJob.perform_later if InnerPerformance.configuration.cleanup_immediately
    end
  end
end
