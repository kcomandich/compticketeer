require 'rails_helper'

describe TicketKind do
  before(:each) do
    @valid_attributes = attributes_for :ticket_kind
  end

  it "expects to create a new instance given valid attributes" do
    TicketKind.create!(@valid_attributes)
  end

  it "expects to set the prefix correctly" do
    expect(create(:ticket_kind, title: 'Volunteer').prefix).to eq 'volunteer'
  end

  it "expects to not set prefix if no title is set" do
    kind = build(:ticket_kind, title: nil, prefix: nil)
    expect(kind).to_not receive(:prefix=)
    kind.set_prefix
  end
end
