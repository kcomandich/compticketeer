require 'rails_helper'

describe ApplicationMailer do
  CHARSET = 'utf-8'

  fixtures :users

  before :each do
    @ticket = create(:ticket)

    @email = TMail::Mail.new
    @email.set_content_type 'text', 'plain', { 'charset' => CHARSET }
    @email.mime_version = '1.0'
  end

  it "expects to not send ticket if ApplicationMailer is not configured" do
    allow(ApplicationMailer).to receive_messages(:configured? => false)

    expect(lambda { ApplicationMailer.ticket_email(@ticket).deliver }).to raise_error(ArgumentError) # TODO use deliver_later when upgraded to Rails 4.2
  end

  it "expects to send ticket with a code if ApplicationMailer is configured" do
    stub_ticket_mailer_secrets

    expect(lambda { ApplicationMailer.ticket_email(@ticket).deliver }).to change(ActionMailer::Base.deliveries, :size).by(1)  # TODO use deliver_later when upgraded to Rails 4.2

    body = ActionMailer::Base.deliveries.last.body
    expect(body).to =~ /#{@ticket.discount_code}/
  end
end
