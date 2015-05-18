require 'rails_helper'

describe "/ticket_kinds/index.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assign(:ticket_kinds, [
      create(:ticket_kind, :title => "value for title", :prefix => "value for prefix", :template => "value for template"),
      create(:ticket_kind, :title => "value for title", :prefix => "value for prefix", :template => "value for template"),
    ])
    assign(:eventbrite_tickets, @eventbrite_tickets = [])
    assign(:event, @event = Event.new)
  end

  it "renders a list of ticket_kinds" do
    render
    expect(response).to have_tag("tr>td", "value for title".to_s, 2)
  end
end
