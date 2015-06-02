require 'rails_helper'

describe "/batches/new.html.erb" do
  include BatchesHelper

  before(:each) do
    assign(:batch, build(:batch, ticket_kind: nil))
    assign(:access_ticket_kinds, [build_stubbed(:ticket_kind)])
    assign(:discount_ticket_kinds, [build_stubbed(:ticket_kind)])
    assign(:event, @event = Event.new)
  end

  it "renders new batch form" do
    render
    expect(rendered).to have_selector("form[action='#{batches_path}'][method=post]")
  end
end
