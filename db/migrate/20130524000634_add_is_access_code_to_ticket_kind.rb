class AddIsAccessCodeToTicketKind < ActiveRecord::Migration
  def self.up
    add_column :ticket_kinds, :is_access_code, :boolean
  end

  def self.down
    remove_column :ticket_kinds, :is_access_code
  end
end
