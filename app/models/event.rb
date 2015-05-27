class Event < ActiveRecord::Base
  attr_accessor :error
  attr_accessor :data
  has_many :tickets

  # tickets for the current event
  def self.eventbrite_tickets
    return [] unless @data
    @data['ticket_classes']
  end

  def self.name_for_ticket(eventbrite_ticket_id)
    return '' unless eventbrite_ticket_id
    eventbrite_tickets.each do |ticket|
      return ticket.name if eventbrite_ticket_id == ticket.id
    end
    return "[Error: current event doesn't contain this ticket. Assign new ticket.]"
  end

  def eventbrite_free_hidden_tickets
    tickets = Event.eventbrite_tickets.map{ |t| t if (t['free'] == true and t['hidden'] == true) }.compact
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def self.title(id)
    return '' unless id
    e = self.where(eventbrite_event_id: id).first
    return "Event ID #{id}" unless e
    e.title
  end
end
