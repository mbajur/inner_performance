# frozen_string_literal: true

module InnerPerformance::Traces
  class View < InnerPerformance::Trace
    store :payload, accessors: [:identifier], coder: JSON, prefix: true

    def self.initialize_for_insert(trace:, event:)
      {
        type: self.class.name,
        name: trace[:name],
        payload: trace[:payload].to_json,
        duration: trace[:duration],
        created_at: trace[:time],
        event_id: event.id,
      }
    end
  end
end
