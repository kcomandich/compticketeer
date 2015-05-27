class Event
  attr_accessor :error
  attr_accessor :data

  def title
    return @error unless @data
    @data['title']
  end

  def self.eventbrite_tickets
    Rails.application.config.eventbrite[:ticket_list]
  end

  def self.name_for_ticket(ticket_id)
    return '' unless ticket_id
    eventbrite_tickets.keys.each do |e_id|
      return eventbrite_tickets[e_id] if ticket_id == e_id
    end
    return "[Error: current event doesn't contain this ticket. Assign new ticket.]"
  end

  def eventbrite_free_hidden_tickets
    return @error unless @data
    tickets = @data['ticket_classes'].map{ |t| t if (t['free'] == true and t['hidden'] == true) }.compact
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def get_event
    unless Rails.application.config.eventbrite[:oauth_token]
      @error = "Couldn't get Eventbrite event because no OAuth token was defined in 'config/initializers/eventbrite.rb'"
      return false
    end

    query = {
      id: Rails.application.config.eventbrite[:event_id],
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
    }
    return Eventbrite.event_get(query, method(:parse_event_get_response))
  end

  def parse_event_get_response(res)
    answer = JSON.parse(res.body)
    if answer['error']
      @error = "Could not get Eventbrite event: #{res.body}"
      return false
    else
      @data = answer['event']
      return true
    end
  end

  def self.events_list
    Rails.application.config.eventbrite[:event_list]
  end

  def self.title(id)
    return '' unless id
    events_list.keys.each do |e_id|
      return events_list[e_id] if id == e_id
    end
  end
end
