class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.text :emails
      t.integer :ticket_kind_id
      t.timestamps
    end
  end
end
