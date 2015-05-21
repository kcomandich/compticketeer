require 'rails_helper'

describe "/batches/show.html.erb" do
  include BatchesHelper
  before(:each) do
    assign(:batch, @batch = create(:batch))
  end

  it "renders a list of tickets" do
    render
    expect(rendered).to have_selector("tr>td", count: 1, text: "foo@bar.com")
    expect(rendered).to have_selector("tr>td", count: 1, text: "baz@qux.org")
  end
end
