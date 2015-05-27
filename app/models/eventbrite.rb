class Eventbrite

  def self.event_get(query, parser)
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    begin
      response = RestClient.get("#{url}/events/#{id}", query)
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

    begin
      return parser.call(response)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{response.body}"
    end
  end

  def self.access_code_new(query, parser)
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    headers = {
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
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

    begin
      return parser.call(response)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{response.body}"
    end
  end

  def self.discounts_new(query, parser)
    url = Rails.application.config.eventbrite[:url]
    id = Rails.application.config.eventbrite[:event_id]
    headers = {
      Authorization: "Bearer #{Rails.application.config.eventbrite[:oauth_token]}",
      content_type: :json
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

    begin
      return parser.call(response)
    rescue JSON::ParserError => e
      return false, "Could not parse Eventbrite JSON response: #{response.body}"
    end
  end
end
