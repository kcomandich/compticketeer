# Be sure to restart your server when you modify this file.
Rails.application.configure do
  config.eventbrite = {
    url: 'https://www.eventbriteapi.com/v3',
    oauth_token: ENV['EVENTBRITE_OATH_TOKEN'],
    event_id: ENV['EVENTBRITE_EVENT_ID'],
    # Identifier of the type of ticket in your Eventbrite event:
    tickets: 'test',

    # Identifiers of all events compticketeer has been used for:
    event_list: {
      '111111111' => 'test 2014',
      '2222222222' => 'test 2015'
    },
    # Identifiers of all tickets compticketeer has been used for:
    # (keep these here instead of using Eventbrite's API repeatedly to call event_get).
    ticket_list: {
      '33333333' => '2015 Speaker'
    },
  }
end
