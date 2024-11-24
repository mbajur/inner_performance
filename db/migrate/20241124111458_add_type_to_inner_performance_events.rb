# frozen_string_literal: true

class AddTypeToInnerPerformanceEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :inner_performance_events, :type, :string
  end
end
