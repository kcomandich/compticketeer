require 'rails_helper'

describe Batch do
  it "expects to not create record and report error if emails are invalid" do
    batch = build(:batch, emails: "foo@bar.com\nomgwtfbbq\n\r\n")

    expect(batch).to_not be_valid

    expect(batch.errors.size).to eq 1
    expect(batch.errors.full_messages.first).to match /omgwtfbbq/
  end

  it "expects to create a new instance given valid attributes" do
    kind = create(:ticket_kind)
    attributes = attributes_for(:batch, ticket_kind_id: kind.id)
    Batch.create!(attributes)
  end

  describe "with valid arguments" do
    before do
      @batch = create(:batch, emails: "foo@bar.com\nbaz@qux.org")
    end

    it "expects to create associated tickets" do
      expect(@batch.tickets.size).to eq 2
      expect(@batch.tickets.map(&:email)).to include("foo@bar.com")
      expect(@batch.tickets.map(&:email)).to include("baz@qux.org")
    end

    describe "when processing tickets" do
      before do
        @batch.tickets.each { |ticket| expect(ticket).to receive :process }
      end

      it "expects to process synchronously" do
        @batch.process
      end

      it "expects to process asynchronously" do
        @batch.process_asynchronously
      end
    end
  end
end
