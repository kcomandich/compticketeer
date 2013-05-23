class AddEventbriteTicketIdToTicketKind < ActiveRecord::Migration
  def self.up
    add_column :ticket_kinds, :eventbrite_ticket_id, :integer
  end

  def self.down
    remove_column :ticket_kinds, :eventbrite_ticket_id
  end
end
