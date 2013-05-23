class Event
  
  attr_accessor :error
  attr_accessor :data

  def title
    return @error unless @data
    @data['title']
  end

  def eventbrite_tickets
    return @error unless @data
    tickets = @data['tickets'].map{ |t| t['ticket'] }
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def eventbrite_free_hidden_tickets
    return @error unless @data
    tickets = @data['tickets'].map{ |t| t['ticket'] if (t['ticket']['price'] == "0.00" and t['ticket']['visible'] == "false") }.compact
    tickets.sort{|a,b| a['name'] <=> b['name']}
  end

  def get_event
    if SECRETS.eventbrite_data['app_key'] == 'test'
      @error = "Couldn't get Eventbrite event because no API key was defined in 'config/secrets.yml'"
      return false
    end

    query = {
      'id' => SECRETS.eventbrite_data['event_id']
    }
    for key in %w[app_key user_key]
      query[key] = SECRETS.eventbrite_data[key]
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
end
