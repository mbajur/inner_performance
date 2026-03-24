# frozen_string_literal: true

module InnerPerformance
  class RecordsQuery
    DEFAULT_SORT_COLUMN = "created_at"
    DEFAULT_SORT_DIRECTION = "desc"

    attr_reader :current_page, :sort_column, :sort_direction

    def initialize(scope:, params:, filterable_attributes: [], sortable_columns: [], per_page: 50)
      @scope = scope
      @params = params
      @filterable_attributes = filterable_attributes.map(&:to_s)
      @sortable_columns = sortable_columns.map(&:to_s)
      @per_page = per_page

      resolve_pagination
      resolve_sorting
    end

    def records
      filtered_scope
        .order(@sort_column => @sort_direction)
        .limit(@per_page)
        .offset(@per_page * (@current_page - 1))
    end

    private

    def filtered_scope
      @filterable_attributes.reduce(@scope) do |scope, attr|
        value = @params.dig(:q, :"#{attr}_eq")
        value.present? ? scope.where(attr => value) : scope
      end
    end

    def resolve_pagination
      page = @params[:page].presence&.to_i
      @current_page = (page.nil? || page < 1) ? 1 : page
    end

    def resolve_sorting
      @sort_column = @sortable_columns.include?(@params[:sort]) ? @params[:sort] : DEFAULT_SORT_COLUMN
      @sort_direction = %w[asc desc].include?(@params[:direction]) ? @params[:direction] : DEFAULT_SORT_DIRECTION
    end
  end
end
