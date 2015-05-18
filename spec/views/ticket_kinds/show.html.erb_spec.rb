require 'rails_helper'

describe "/ticket_kinds/show.html.erb" do
  include TicketKindsHelper
  before(:each) do
    assign(:ticket_kind, @ticket_kind = TicketKind.create!(
      title: "value for title",
      prefix: "value for prefix",
      subject: "value for subject",
      template: "value for template"
    ))
    assign(:eventbrite_tickets, @eventbrite_tickets = [])
    assign(:event, @event = Event.new)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match /value\ for\ title/
    expect(rendered).to match /value\ for\ prefix/
    expect(rendered).to match /value\ for\ subject/
    expect(rendered).to match /value\ for\ template/
  end
end
