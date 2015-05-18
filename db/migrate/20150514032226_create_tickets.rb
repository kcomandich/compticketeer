class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :ticket_kind_id
      t.integer :batch_id
      t.string :email
      t.text :report, :limit => 2048
      t.datetime :processed_at
      t.string :discount_code
      t.string :status
      t.integer :event_id

      t.timestamps
    end
  end
end
