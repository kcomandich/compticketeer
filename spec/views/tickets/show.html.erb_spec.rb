require 'rails_helper'
require 'support/factory_girl'
require 'support/disable_register_code'

describe "/tickets/show.html.erb" do
  include TicketsHelper
  before(:each) do
    assign(:ticket, @ticket = create(:ticket))
  end

  it "renders attributes in <p>" do
    render
    expect(response).to have_text(/#{@ticket.email}/)
    expect(response).to have_text(/#{@ticket.report}/)
  end
end
