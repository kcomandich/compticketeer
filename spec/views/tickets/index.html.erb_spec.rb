require 'rails_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assign(:tickets, [
      create(:ticket, :email => "foo@bar.com"),
    ])
  end

  it "renders a list of tickets" do
    render
    expect(rendered).to have_selector("tr>td", count: 1, text: /foo@bar.com/)
  end
end
