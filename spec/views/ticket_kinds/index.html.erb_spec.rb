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
    expect(rendered).to have_selector("tr>td", count: 2, text: "value for title")
  end
end
