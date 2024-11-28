# frozen_string_literal: true

InnerPerformance::Engine.routes.draw do
  resources :events, only: [:index]

  root to: "dashboard#index"
end
