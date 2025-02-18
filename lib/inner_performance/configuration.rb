# frozen_string_literal: true

module InnerPerformance
  class Configuration
    attr_accessor :sample_rates,
      :events_retention,
      :medium_duration_range,
      :ignore_rules,
      :cleanup_immediately,
      :traces_enabled,
      :ignored_event_names

    def initialize
      @sample_rates = {
        "process_action.action_controller" => 2,
        "perform.active_job" => 100,
      }
      @events_retention = 1.week
      @medium_duration_range = [200, 999]
      @ignore_rules = [
        proc { |event| rand(100) > InnerPerformance.configuration.sample_rates[event.name.to_s] },
        proc { |event| (event.payload[:job]&.class&.name || "").include?("InnerPerformance") },
      ]
      @cleanup_immediately = false
      @traces_enabled = false
      @ignored_event_names = [
        "SCHEMA",
        "TRANSACTION",
        "ActiveRecord::InternalMetadata Load",
        "ActiveRecord::SchemaMigration Load",
      ]
    end
  end
end
