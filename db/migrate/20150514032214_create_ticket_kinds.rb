class CreateTicketKinds < ActiveRecord::Migration
  def change
    create_table :ticket_kinds do |t|
      t.string :title
      t.string :prefix
      t.text :template
      t.string :subject
      t.integer :eventbrite_ticket_id
      t.boolean :is_access_code

      t.timestamps
    end
  end
end
