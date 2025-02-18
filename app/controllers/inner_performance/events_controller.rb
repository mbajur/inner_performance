# frozen_string_literal: true

module InnerPerformance
  class EventsController < ApplicationController
    include Pagy::Backend

    def index
      @q = InnerPerformance::Event.all.ransack(params[:q])
      @q.sorts = "created_at desc" if @q.sorts.empty?
      @pagy, @events = pagy(@q.result)
    end

    def show
      @event = InnerPerformance::Event.find(params[:id])
      @traces = @event.traces.order(created_at: :asc)
    end
  end
end
