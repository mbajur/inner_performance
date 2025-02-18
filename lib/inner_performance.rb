# frozen_string_literal: true

require "inner_performance/version"
require "inner_performance/engine"
require "inner_performance/configuration"

require_relative "inner_performance/current_request"

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
      ActiveSupport::Notifications.subscribe("render_template.action_view") do |event|
        CurrentRequest.current.trace({
          group: :view,
          name: event.name,
          payload: { identifier: event.payload[:identifier] },
          duration: event.duration.round(2),
        }) if InnerPerformance.configuration.traces_enabled
      end

      ActiveSupport::Notifications.subscribe("render_partial.action_view") do |event|
        CurrentRequest.current.trace({
          group: :view,
          name: event.name,
          payload: { identifier: event.payload[:identifier] },
          duration: event.duration.round(2),
        }) if InnerPerformance.configuration.traces_enabled
      end

      ActiveSupport::Notifications.subscribe("sql.active_record") do |event|
        unless event.payload[:name].in?(InnerPerformance.configuration.ignored_event_names)
          CurrentRequest.current.trace({
            group: :db,
            name: event.name,
            payload: { name: event.payload[:name], sql: event.payload[:sql] },
            duration: event.duration.round(2),
          }) if InnerPerformance.configuration.traces_enabled
        end
      end

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
            traces: CurrentRequest.current.traces,
          )
        end

        CurrentRequest.cleanup
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
            traces: CurrentRequest.current.traces,
          )
        end

        CurrentRequest.cleanup
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
