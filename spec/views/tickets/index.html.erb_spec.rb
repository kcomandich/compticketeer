require 'spec_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper

  before(:each) do
    assigns[:tickets] = [
      Factory(:ticket, :email => "foo@bar.com"),
    ]
  end

  it "renders a list of tickets" do
    render
    response.should have_tag("tr>td", /foo@bar.com/, 2)
  end
end
