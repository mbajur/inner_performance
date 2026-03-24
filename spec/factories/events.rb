# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: "InnerPerformance::Event" do
    name { "x" }
    event { "process_action.action_controller" }
    duration { 0 }
  end
end
