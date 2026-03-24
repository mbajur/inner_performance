# frozen_string_literal: true

module InnerPerformance
  class EventsController < ApplicationController
    RESULTS_PER_PAGE = 50
    SORTABLE_COLUMNS = %w[name duration db_runtime created_at].freeze

    def index
      @current_page = params[:page].presence&.to_i

      if current_page.nil? || current_page < 1
        @current_page = 1
      end

      scope = InnerPerformance::Event.all
      scope = scope.where(name: params.dig(:q, :name_eq)) if params.dig(:q, :name_eq).present?
      scope = scope.where(event: params.dig(:q, :event_eq)) if params.dig(:q, :event_eq).present?

      @sort_column = SORTABLE_COLUMNS.include?(params[:sort]) ? params[:sort] : "created_at"
      @sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

      @events = scope
        .order(@sort_column => @sort_direction)
        .limit(RESULTS_PER_PAGE)
        .offset(RESULTS_PER_PAGE * (@current_page - 1))
    end

    def show
      @event = InnerPerformance::Event.find(params[:id])
      @traces = @event.traces.order(created_at: :asc)
    end
  end
end
