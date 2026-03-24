# frozen_string_literal: true

module InnerPerformance
  class EventsController < ApplicationController
    RESULTS_PER_PAGE = 50
    SORTABLE_COLUMNS = %w[name duration db_runtime created_at].freeze

    def index
      query = InnerPerformance::RecordsQuery.new(
        scope: InnerPerformance::Event.all,
        params: params,
        filterable_attributes: %w[name event],
        sortable_columns: SORTABLE_COLUMNS,
        per_page: RESULTS_PER_PAGE,
      )

      @current_page = query.current_page
      @sort_column = query.sort_column
      @sort_direction = query.sort_direction
      @events = query.records
    end

    def show
      @event = InnerPerformance::Event.find(params[:id])
      @traces = @event.traces.order(created_at: :asc)
    end
  end
end
