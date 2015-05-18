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
    expect(response).to have_tag("tr>td", /foo@bar.com/, 2)
  end
end
