# frozen_string_literal: true

module InnerPerformance
  module Traces
    class Db < InnerPerformance::Trace
      store :payload, accessors: [:sql, :name], coder: JSON, prefix: true

      class << self
        def initialize_for_insert(trace:, event:)
          {
            type: name,
            name: trace[:name],
            payload: trace[:payload].to_json,
            duration: trace[:duration],
            created_at: trace[:time],
            event_id: event.id,
          }
        end
      end
    end
  end
end
