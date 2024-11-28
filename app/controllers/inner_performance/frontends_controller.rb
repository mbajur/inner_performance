# frozen_string_literal: true

module InnerPerformance
  class FrontendsController < ApplicationController
    protect_from_forgery with: :exception
    skip_after_action :verify_same_origin_request, raise: false

    before_action do
      expires_in 1.year, public: true
    end

    def self.asset_path(path)
      Engine.root.join("app/frontend/inner_performance", path)
    end

    STATIC_ASSETS = {
      css: {
        application: asset_path("application.css"),
        bootstrap: asset_path("vendor/bootstrap.min.css"),
      },
    }.freeze

    def static
      file_stem = params[:stem]&.to_sym
      file_format = params[:format]&.to_sym

      file_path = STATIC_ASSETS.dig(file_format, file_stem) || raise(ActionController::RoutingError, "Not Found")
      send_file file_path, disposition: "inline"
    end
  end
end
