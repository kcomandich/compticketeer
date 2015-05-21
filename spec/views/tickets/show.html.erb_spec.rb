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
    expect(rendered).to match /#{@ticket.email}/
    expect(rendered).to match /#{@ticket.report}/
  end
end
