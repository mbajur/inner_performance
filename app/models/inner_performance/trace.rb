# frozen_string_literal: true

module InnerPerformance
  class Trace < ApplicationRecord
    belongs_to :event
  end
end
