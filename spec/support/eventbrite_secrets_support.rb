# Stub Rails.application.config.eventbrite with valid data.
def stub_eventbrite_config
  allow(Rails.application.config).to receive_messages(eventbrite: {
    url: 'https://www.eventbriteapi.com/v3',
    oauth_token: '123456',
    event_id: '789',
    tickets:  '123',
  })
end

# Stub Rails.application.config.eventbrite with invalid data.
def stub_invalid_eventbrite_config
  allow(Rails.application.config).to receive_messages(eventbrite: { })
end

# Stub successful event_get call to Eventbrite API
def stub_eventbrite_event_get
  mock_event = { name: { text: 'test' }, ticket_classes: [ { id: '1234', name: 'test', free: true, hidden: true }]}
  mock_body = { process: { id: 268329, message: 'event_get : Complete', status: 'OK'}, event: mock_event }
  response = double('Yay!', to_hash: {"Status" => ["200 OK"]}, code: 200)
  res = RestClient::Response.create(mock_body.to_json, response, {}, {})
  expect(RestClient).to receive(:get).and_return(res)
end
