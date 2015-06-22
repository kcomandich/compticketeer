class Eventbrite
  @url = Rails.application.config.eventbrite[:url]
  @eventbrite_event_id = Rails.application.config.eventbrite[:event_id]
  @headers = {
    Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
    content_type: :json
  }

  def self.get_event_ticket_classes
    return unless @event
    status, @event.error = eventbrite_request(RestClient.method(:get), method(:parse_event_get_ticket_classes), "#{@url}/events/#{@eventbrite_event_id}/ticket_classes")
  end

  def self.get_event_details
    @event = Event.find_or_create_by(eventbrite_event_id: @eventbrite_event_id)
    unless Rails.application.config.eventbrite[:oauth_token]
      @event.error = "Couldn't get Eventbrite event because no OAuth token was defined in 'config/initializers/eventbrite.rb'"
      return @event
    end

    status, @event.error = eventbrite_request(RestClient.method(:get), method(:parse_event_get_response), "#{@url}/events/#{@eventbrite_event_id}")
    @event.update_attribute :title, @event.data['name']['text'] if status
    get_event_ticket_classes
    return @event
  end

  def self.new_access_code(code, ticket_id)
    query = {
      access_code: {
        code: code,
        quantity_available: 3,
        ticket_ids: [ticket_id]
      }
    }
    return eventbrite_request(RestClient.method(:post), method(:parse_code_new_response), "#{@url}/events/#{@eventbrite_event_id}/access_codes/", query.to_json)
  end

  def self.new_discount_code(code, ticket_id)
    query = {
      discount: {
        code: code,
        percent_off: 100,
        quantity_available: 3,
        ticket_ids: [ticket_id],
      }
    }
    return eventbrite_request(RestClient.method(:post), method(:parse_code_new_response), "#{@url}/events/#{@eventbrite_event_id}/discounts/", query.to_json)
  end

  private

  def self.eventbrite_request(request_method, parse_method, *request_args)
    begin
      response = request_method.call(*request_args, @headers)
    rescue RestClient::ExceptionWithResponse => e
      if response_code = e.http_code and response_body = e.http_body
        begin
          error = JSON.parse(response_body)
          return false, "Eventbrite request failed, got HTTP status #{response_code}: #{error}"
        rescue JSON::ParserError
          return false, "Could not parse Eventbrite JSON response: #{response_body.inspect} (HTTP response code was #{response_code})"
        end
      end
      return false, "Eventbrite request failed: #{e.response}"
    end

    return parse_method.call(response)
  end

  def self.parse_event_get_response(res)
    begin
      answer = JSON.parse(res.body)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{res.body}"
    end
    if answer['error']
      return false, "Could not get Eventbrite event: #{res.body}"
    else
      @event.update_attribute :data, answer
      return true
    end
  end

  def self.parse_code_new_response(res)
    begin
      answer = JSON.parse(res.body)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{res.body}"
    end
    if answer['error']
      if answer['error'].try(:[], 'error_message').to_s =~ /already in use/
        # Code exists succeeded
        return true, "Eventbrite code already exists: #{res.body}"
      else
        # Has error of some other kind
        return false, "Could not register Eventbrite code: #{res.body}"
      end
    else
      # Registration succeeded
      return true, "Registered Eventbrite code"
    end
  end

  def self.parse_event_get_ticket_classes(res)
    begin
      answer = JSON.parse(res.body)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{res.body}"
    end
    if answer['error']
      return false, "Could not get Eventbrite event: #{res.body}"
    else
      @event.update_attribute :eventbrite_tickets, answer['ticket_classes']
      return true
    end
  end
end
