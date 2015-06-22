class Event < ActiveRecord::Base
  attr_accessor :error
  attr_accessor :data
  # tickets for the current event
  attr_accessor :eventbrite_tickets
  has_many :tickets

  def name_for_ticket(eventbrite_ticket_id)
    return '' unless eventbrite_ticket_id

    ticket = eventbrite_tickets.find{ |t| t['id'].to_i == eventbrite_ticket_id }
    if ticket
      return ticket['name']
    else
      return "[Error: current event doesn't contain this ticket. Assign new ticket.]"
    end
  end

  def eventbrite_free_hidden_tickets
    tickets = eventbrite_tickets.map{ |t| t if (t['free'] == true and t['hidden'] == true) }.compact
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def eventbrite_paid_tickets
    tickets = eventbrite_tickets.map{ |t| t if (t['free'] == false) }.compact
  end

  def self.title(id)
    return '' unless id
    e = where(eventbrite_event_id: id).first
    return "Event ID #{id}" unless e
    e.title
  end
end
