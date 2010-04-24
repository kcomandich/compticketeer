require 'spec_helper'

describe TicketKind do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :prefix => "value for prefix",
      :template => "value for template"
    }
  end

  it "should create a new instance given valid attributes" do
    TicketKind.create!(@valid_attributes)
  end
end