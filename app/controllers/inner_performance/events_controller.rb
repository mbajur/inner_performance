# frozen_string_literal: true

module InnerPerformance
  class EventsController < ApplicationController
    RESULTS_PER_PAGE = 50

    def index
      @current_page = params[:page].presence&.to_i

      if current_page.nil? || current_page < 1
        @current_page = 1
      end

      @q = InnerPerformance::Event
        .all
        .limit(RESULTS_PER_PAGE)
        .offset(RESULTS_PER_PAGE * (@current_page - 1))
        .ransack(params[:q])

      @q.sorts = "created_at desc" if @q.sorts.empty?

      @events = @q.result
    end

    def show
      @event = InnerPerformance::Event.find(params[:id])
      @traces = @event.traces.order(created_at: :asc)
    end
  end
end
