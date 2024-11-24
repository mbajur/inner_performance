# frozen_string_literal: true

module InnerPerformance
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
