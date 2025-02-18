class CreateInnerPerformanceTraces < ActiveRecord::Migration[8.0]
  def change
    create_table :inner_performance_traces do |t|
      t.references :event, null: false, foreign_key: { to_table: :inner_performance_events }
      t.string :name
      t.string :type
      t.json :payload, default: {}
      t.decimal :duration

      t.timestamps
    end
  end
end
