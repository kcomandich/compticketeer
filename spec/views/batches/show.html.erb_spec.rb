require 'rails_helper'

describe "/batches/show.html.erb" do
  include BatchesHelper
  before(:each) do
    assign(:batch, @batch = build_stubbed(:batch))
  end

  it "renders attributes in <p>" do
    render
  end
end
