# frozen_string_literal: true

module InnerPerformance
  class TraceForInsertInitializer
    def self.new(trace:, event:)
      class_from_group(trace).initialize_for_insert(trace: trace, event: event)
    end

    def self.class_from_group(trace)
      case trace[:group]
      when :db then InnerPerformance::Traces::Db
      when :view then InnerPerformance::Traces::View
      else raise ArgumentError, "Invalid trace group: #{trace[:group]}"
      end
    end
  end
end
