require 'rails_helper'

describe ApplicationMailer do
  CHARSET = 'utf-8'

  before :each do
    @ticket = create(:ticket)
  end

  it "expects to not send ticket if ApplicationMailer is not configured" do
    allow(ApplicationMailer).to receive_messages(:configured? => false)

    expect(lambda { ApplicationMailer.ticket_email(@ticket).deliver }).to raise_error(ArgumentError) # TODO use deliver_later when upgraded to Rails 4.2
  end

  it "expects to send ticket with a code if ApplicationMailer is configured" do
    stub_ticket_mailer_secrets

    expect(lambda { ApplicationMailer.ticket_email(@ticket).deliver }).to change(ActionMailer::Base.deliveries, :size).by(1)  # TODO use deliver_later when upgraded to Rails 4.2

    body = ActionMailer::Base.deliveries.last.body
    expect(body).to match /#{@ticket.discount_code}/
  end
end
