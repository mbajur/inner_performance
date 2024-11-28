# frozen_string_literal: true

module InnerPerformance
  class Engine < ::Rails::Engine
    isolate_namespace InnerPerformance

    config.generators do |g|
      g.test_framework(:rspec)
    end

    initializer "inner_performance.install" do
      InnerPerformance.install!
    end

    initializer "inner_performance.assets.precompile" do |app|
      # this initializer is only called when sprockets is in use
      app.config.assets.precompile << "inner_performance_manifest.js"
    end
  end
end
