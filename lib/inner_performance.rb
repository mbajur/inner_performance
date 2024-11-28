# frozen_string_literal: true

require "inner_performance/version"
require "inner_performance/engine"
require "inner_performance/configuration"

require "ransack"
require "pagy"

module InnerPerformance
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def install!
      ActiveSupport::Notifications.subscribe("process_action.action_controller") do |event|
        if save_event?(event)
          InnerPerformance::SaveEventJob.perform_later(
            type: InnerPerformance::Events::ProcessActionActionController.name,
            created_at: event.payload[:started],
            event: event.name,
            name: "#{event.payload[:controller]}##{event.payload[:action]}",
            duration: event.duration,
            db_runtime: event.payload[:db_runtime],
            properties: {
              view_runtime: event.payload[:view_runtime],
            },
          )
        end
      end

      ActiveSupport::Notifications.subscribe("perform.active_job") do |event|
        if save_event?(event)
          InnerPerformance::SaveEventJob.perform_later(
            type: InnerPerformance::Events::PerformActiveJob.name,
            created_at: event.payload[:started],
            event: event.name,
            name: event.payload[:job].class.name,
            duration: event.duration,
            db_runtime: event.payload[:db_runtime],
          )
        end
      end
    end

    # Check if all the ignore_rules returns false. If so, save the event.
    def save_event?(event)
      InnerPerformance.configuration.ignore_rules.find do |rule|
        rule.call(event) == true
      end.nil?
    end
  end
end
