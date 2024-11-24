# frozen_string_literal: true

module InnerPerformance
  class Engine < ::Rails::Engine
    isolate_namespace InnerPerformance

    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'inner_performance.install' do
      InnerPerformance.install!
    end
  end
end
