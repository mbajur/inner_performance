# frozen_string_literal: true

module InnerPerformance
  class SaveEventJob < ApplicationJob
    def perform(type:, created_at:, event:, name:, duration:, db_runtime:, properties: {})
      InnerPerformance::Event.create(
        type: type,
        created_at: created_at,
        event: event,
        name: name,
        duration: duration,
        db_runtime: db_runtime,
        properties: properties,
      )
    end
  end
end
