class RemoveDefaultValueFromInnerPerformanceEventsProperties < ActiveRecord::Migration[8.0]
  def change
    change_column_default(:inner_performance_events, :properties, nil)
  end
end
