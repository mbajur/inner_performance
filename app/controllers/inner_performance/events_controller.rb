module InnerPerformance
  class EventsController < ApplicationController
    include Pagy::Backend
    include Pagy::Frontend

    def index
      @q = InnerPerformance::Event.all.ransack(params[:q])
      @q.sorts = "created_at desc" if @q.sorts.empty?
      @pagy, @events = pagy(@q.result)
    end
  end
end
