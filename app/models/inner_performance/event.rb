# frozen_string_literal: true

module InnerPerformance
  class Event < ApplicationRecord
    has_many :traces, dependent: :destroy

    serialize :properties, coder: JSON

    def self.ransackable_attributes(_auth_object = nil)
      ["created_at", "db_runtime", "duration", "event", "format", "id", "name"]
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
