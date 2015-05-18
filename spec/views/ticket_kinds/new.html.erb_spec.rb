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
    assign(:eventbrite_tickets, @eventbrite_tickets = [])
  end

  it "renders new ticket_kind form" do
    render

    expect(view).to render_template(partial: "_form")
    expect(rendered).to have_selector("form[action=?][method=post]", ticket_kinds_path)
# TODO
#    do |node|
#      expect(node).to have_selector("input#ticket_kind_title[name=?]", "ticket_kind[title]")
#      expect(node).to have_selector("input#ticket_kind_prefix[name=?]", "ticket_kind[prefix]")
#      expect(node).to have_selector("textarea#ticket_kind_template[name=?]", "ticket_kind[template]")
#    end
  end
end
