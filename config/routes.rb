# frozen_string_literal: true

InnerPerformance::Engine.routes.draw do
  resources :events, only: [:index]

  root to: "dashboard#index"

  scope :frontend, controller: :frontends, defaults: { version: InnerPerformance::VERSION.tr(".", "-") } do
    get "static/:version/:stem", action: :static, as: :frontend_static
  end
end
