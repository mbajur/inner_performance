# frozen_string_literal: true

InnerPerformance.configuration do |config|
  config.sample_rates = {
    "process_action.action_controller" => 100,
    "perform.active_job" => 100,
  }
end
