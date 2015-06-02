require 'rails_helper'

describe "/ticket_kinds/new.html.erb" do
  include TicketKindsHelper

  before(:each) do
    assign(:ticket_kind, TicketKind.new(
      title: "value for title",
      prefix: "value for prefix",
      subject: "value for subject",
      template: "value for template"
    ))
    assign(:eventbrite_paid_tickets, @eventbrite_paid_tickets = [])
    assign(:eventbrite_free_hidden_tickets, @eventbrite_free_hidden_tickets = [])
  end

  it "renders new ticket_kind form" do
    render

    expect(rendered).to have_selector("form[action='#{ticket_kinds_path}'][method=post]" ) do |node|
      expect(node).to have_selector("input#ticket_kind_title[name='#{@ticket_kind[title]}']")
      expect(node).to have_selector("input#ticket_kind_prefix[name='#{@ticket_kind[prefix]}']")
      expect(node).to have_selector("textarea#ticket_kind_template[name='#{@ticket_kind[template]}']")
    end
  end
end
