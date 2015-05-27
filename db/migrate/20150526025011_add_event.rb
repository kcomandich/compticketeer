class AddEvent < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :title
      t.integer :eventbrite_event_id, limit: 8
    end
    add_index :events, [:eventbrite_event_id], name: 'index_events_on_eventbrite_event_id', unique: true
  end
end
