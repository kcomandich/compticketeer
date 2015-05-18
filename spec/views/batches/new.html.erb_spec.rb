require 'rails_helper'

describe "/batches/new.html.erb" do
  include BatchesHelper

  before(:each) do
    assign(:batch, build(:batch, :ticket_kind => nil))
    assign(:access_ticket_kinds, [build_stubbed(:ticket_kind)])
    assign(:discount_ticket_kinds, [build_stubbed(:ticket_kind)])
  end

  it "renders new batch form" do
    render

    expect(response).to have_tag("form[action=?][method=post]", batches_path) do
    end
  end
end
