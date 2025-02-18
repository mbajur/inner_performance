class RemoveDefaultValueFromInnerPerformanceEventsProperties < ActiveRecord::Migration[7.1]
  def change
    change_column_default(:inner_performance_events, :properties, nil)
  end
end
