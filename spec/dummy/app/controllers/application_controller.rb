# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def dummy
    @events = InnerPerformance::Event.all
    @traces = InnerPerformance::Trace.all
  end
end
