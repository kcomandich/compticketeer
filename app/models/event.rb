class Event
  attr_accessor :error
  attr_accessor :data

  def title
    return @error unless @data
    @data['title']
  end

  def self.eventbrite_tickets
    Rails.application.secrets.eventbrite_data['ticket_list']
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
    tickets = @data['tickets'].map{ |t| t['ticket'] if (t['ticket']['price'] == "0.00" and t['ticket']['visible'] == "false") }.compact
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def get_event
    if Rails.application.secrets.eventbrite_data['app_key'] == 'test'
      @error = "Couldn't get Eventbrite event because no API key was defined in 'config/secrets.yml'"
      return false
    end

    query = {
      'id' => Rails.application.secrets.eventbrite_data['event_id']
    }
    for key in %w[app_key user_key]
      query[key] = Rails.application.secrets.eventbrite_data[key]
    end

    return Eventbrite.request('event_get', query, method(:parse_event_get_response))
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
    Rails.application.secrets.eventbrite_data['event_list']
  end

  def self.title(id)
    return '' unless id
    events_list.keys.each do |e_id|
      return events_list[e_id] if id == e_id
    end
  end
end
