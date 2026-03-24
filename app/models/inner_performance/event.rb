# frozen_string_literal: true

module InnerPerformance
  class Event < ApplicationRecord
    has_many :traces, dependent: :destroy

    serialize :properties, coder: JSON
  end
end
