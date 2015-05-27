class Eventbrite


  def self.get_event
    @event = Event.find_or_create_by(eventbrite_event_id: Rails.application.config.eventbrite[:event_id])
    unless Rails.application.config.eventbrite[:oauth_token]
      @event.error = "Couldn't get Eventbrite event because no OAuth token was defined in 'config/initializers/eventbrite.rb'"
      return @event
    end

    self.get_event_details
    @event.update_attribute :title, @event.data['name']['text']
    return @event
  end

  def self.get_event_details
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    headers = {
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
    }
    begin
      response = RestClient.get("#{url}/events/#{id}", headers)
    rescue RestClient::ExceptionWithResponse => e
      if response_code = e.http_code and response_body = e.http_body
        begin
          error = JSON.parse(response_body)
          @event.error = "Eventbrite request failed, got HTTP status #{response_code}: #{error}"
          return false
        rescue JSON::ParserError
          @event.error = "Could not parse Eventbrite JSON response: #{response_body.inspect} (HTTP response code was #{response_code})"
          return false
        end
      end
      @event.error = "Eventbrite request failed: #{e.response}"
      return false
    end

    return parse_event_get_response(response)
  end

  def self.new_access_code(code, ticket_id)
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    headers = {
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
    }
    query = {
      access_code: {
        code: code,
        quantity_available: 3,
        ticket_ids: [ticket_id]
      }
    }
    begin
      response = RestClient.post("#{url}/events/#{id}/access_codes/", query.to_json, headers)
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

    return parse_code_new_response(response)
  end

  def self.new_discount_code(code, ticket_id)
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    headers = {
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
    }
    query = {
      discount: {
        code: code,
        percent_off: 100,
        quantity_available: 3,
        ticket_ids: [ticket_id],
      }
    }
    begin
      response = RestClient.post("#{url}/events/#{id}/discounts/", query.to_json, headers)
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

    return parse_code_new_response(response)
  end

  private

  def self.parse_event_get_response(res)
    begin
      answer = JSON.parse(res.body)
    rescue JSON::ParserError => e
      @event.error = "Could not parse Eventbrite JSON response: #{res.body}"
      return false
    end
    if answer['error']
      @event.error = "Could not get Eventbrite event: #{res.body}"
      return false
    else
      @event.data = answer['event']
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
end
