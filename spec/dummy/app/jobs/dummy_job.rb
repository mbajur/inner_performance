# frozen_string_literal: true

class DummyJob < ApplicationJob
  def perform
    InnerPerformance::Event.all.load
    InnerPerformance::Trace.all.load
    true
  end
end
