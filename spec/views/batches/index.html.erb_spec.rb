require 'rails_helper'

describe "/batches/index.html.erb" do
  include BatchesHelper

  before(:each) do
    assign(:batches, [
      build_stubbed(:batch),
      build_stubbed(:batch),
    ])
  end

  it "renders a list of batches" do
    render
  end
end
