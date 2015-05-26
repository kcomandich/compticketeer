# Stub Rails.application.config.eventbrite with valid data.
def stub_eventbrite_config
  allow(Rails.application.config).to receive_messages(eventbrite: {
    app_key:  '123',
    user_key: '456',
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
  mock_event = { title: 'test', tickets: [ ticket: { id: '1234', name: 'test', price: '0.00', visible:false }]}
  mock_body = { process: { id: 268329, message: 'event_get : Complete', status: 'OK'}, event: mock_event }
  res = Net::HTTPOK.new('1.1', '200', 'Yay!')
  allow(res).to receive_messages(body: mock_body.to_json)
  expect(Net::HTTP).to receive(:post_form).and_return(res)
end
