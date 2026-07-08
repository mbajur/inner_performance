# frozen_string_literal: true

module InnerPerformance
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    if InnerPerformance.configuration.enabled && InnerPerformance.configuration.connects_to
      connects_to(**InnerPerformance.configuration.connects_to)
    end
  end
end
