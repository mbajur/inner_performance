# frozen_string_literal: true

module InnerPerformance
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    connects_to(**InnerPerformance.configuration.connects_to) if InnerPerformance.configuration.connects_to
  end
end
