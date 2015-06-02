# Be sure to restart your server when you modify this file.
Rails.application.configure do
  config.eventbrite = {
    url: 'https://www.eventbriteapi.com/v3',
    oauth_token: ENV['EVENTBRITE_OATH_TOKEN'],
    event_id: ENV['EVENTBRITE_EVENT_ID']
  }
end
