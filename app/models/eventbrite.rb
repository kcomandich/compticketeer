class Eventbrite

  def self.request(request, query, parser)
    res = Net::HTTP.post_form(URI.parse("http://www.eventbrite.com/json/#{request}"), query)

    case res
    when Net::HTTPOK
      begin
        return parser.call(res)
      rescue JSON::ParserError => e
        return false, "Could not parse Eventbrite JSON response: #{res.body}"
      end
    else
      return false, "Eventbrite request failed, got HTTP status #{res.code}: #{res.body}"
    end
  end
end
