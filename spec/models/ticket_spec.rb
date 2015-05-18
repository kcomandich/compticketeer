require 'rails_helper'

describe Ticket do
  it "expects to create a new instance given valid attributes" do
    create(:ticket)
  end

  describe "status" do
    it "expects to have 'created' status intially" do
      expect(create(:ticket, :report => nil).status).to eq 'created'
    end
  end

  describe "status_label" do
    it "expects to have a status label" do
      expect(create(:ticket).status_label).to_not be_blank
    end

    it "expects to be capitalized" do
      ticket = create(:ticket)

      expect(ticket.status_label).to eq ticket.status_label.capitalize
    end

    it "expects to be able to emit spaces" do
      expect(create(:ticket, :status => :sending_email).status_label).to match /\s/
    end

    it "expects to put '...' at end of unfinished status" do
      expect(create(:ticket, :status => :sending_email).status_label).to match /\.\.\.$/
    end

    it "expects to put '!' at end of error" do
      expect(create(:ticket, :status => :failed_to_send_email).status_label).to match /!$/
    end
  end

  describe "done?" do
    it "expects to be true for successfully finished work" do
      expect(create(:ticket, :status => :sent_email).done?).to be_truthy
    end

    it "expects to be true for failed finished work" do
      expect(create(:ticket, :status => :failed_to_send_email).done?).to be_truthy
    end
    
    it "expects to be false for unfinished work" do
      expect(create(:ticket, :status => :sending_email).done?).to be_falsey
    end
  end

  describe "success?" do
    it "expects to be true if successfully completed" do
      expect(create(:ticket, :status => :sent_email).success?).to be_truthy
    end

    it "expects to be false if ended in failure" do
      expect(create(:ticket, :status => :failed_to_send_email).success?).to be_falsey
    end

    it "expects to be nil if not done" do
      expect(create(:ticket, :status => :sending_email).success?).to be_nil
    end
  end

  describe "ticket_kind" do
    it "expects to assign ticket_kind from the assigned batch" do
      kind = create(:ticket_kind)
      batch = create(:batch, :ticket_kind => kind)
      expect(create(:ticket, :batch => batch).ticket_kind).to eq kind
    end

    it "expects to not reset ticket_kind if already set" do
      kind = build(:ticket_kind)
      ticket = build(:ticket, :ticket_kind => kind)
      expect(ticket).to_not receive(:ticket_kind=)
      ticket.save!
    end
  end

  describe "discount_code" do
    it "expects to be generated" do
      kind = create(:ticket_kind, :title => 'Speaker')
      batch = create(:batch, :ticket_kind => kind)
      expect(create(:ticket, :email => "foo@bar.com", :batch => batch).discount_code).to match /^speaker_foobarcom/
    end

    it "expects to not be generated if already set" do
      ticket = create(:ticket)
      expect(ticket).to_not receive(:discount_code=)
      ticket.generate_discount_code
    end

    it "expects to not be generated if no email set" do
      ticket = build(:ticket, :email => nil)
      expect(ticket).to_not receive(:discount_code=)
      ticket.generate_discount_code
    end

    it "expects to generate the same discount code every time" do
      ticket = build(:ticket)
      ticket.discount_code = nil
      code1 = ticket.generate_discount_code
      ticket.discount_code = nil
      code2 = ticket.generate_discount_code
      expect(code1).to eq code2
    end
  end

  describe "process" do
      before do
        stub_ticket_mailer_secrets
      end

    it "expects to register code and send email" do
      ticket = create(:ticket)
      expect(ticket).to receive(:register_discount_code)
      expect(ticket).to receive(:send_email)
      ticket.process
    end
  end

  describe "register_discount_code" do
    it "expects to not register during tests unless overridden" do
      ticket = create(:ticket)
      expect(Net::HTTP).to_not receive(:post_form)

      expect(Ticket.disable_register_code).to be_truthy
      expect(ticket.register_discount_code).to be_falsey
    end

    it "expects to register" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      allow(res).to receive_messages(:body => {"process"=>{"id"=>268329, "message"=>"discount_new : Complete ", "status"=>"OK"}}.to_json)
      expect(Net::HTTP).to receive(:post_form).and_return(res)
      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_truthy
      expect(ticket.status).to eq "registered_code"
    end

    it "expects to succeed if discount code already exists" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      allow(res).to receive_messages(:body => {"error"=>{"error_message"=>"The discount code \"volunteer_foo\" is already in use.", "error_type"=>"Discount error"}}.to_json)
      expect(Net::HTTP).to receive(:post_form).and_return(res)

      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_truthy
      expect(ticket.status).to eq "registered_code"
      expect(ticket.report).to match /already exists/
    end

    it "expects to fail if EventBrite responds with an API error" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      allow(res).to receive_messages(:body => {"error"=>{"error_message"=>"Please enter a valid discount code.", "error_type"=>"Discount error"}}.to_json)
      expect(Net::HTTP).to receive(:post_form).and_return(res)
      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_falsey
      expect(ticket.report).to match /Discount error/
      expect(ticket.status).to eq "failed_to_register_code"
    end

    it "expects to fail if EventBrite responds with invalid JSON" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPOK.new('1.1', '200', 'Yay!')
      allow(res).to receive_messages(:body => 'invalid/json')
      expect(Net::HTTP).to receive(:post_form).and_return(res)
      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_falsey
      expect(ticket.report).to match /JSON/
      expect(ticket.status).to eq "failed_to_register_code"
    end

    it "expects to fail if EventBrite rejects request" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_eventbrite_secrets

      res = Net::HTTPForbidden.new('1.1', '401', 'Go away!')
      allow(res).to receive_messages(:body => 'Get off my lawn!')
      expect(Net::HTTP).to receive(:post_form).and_return(res)
      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_falsey
      expect(ticket.report).to match /401.+Get off my lawn/
      expect(ticket.status).to eq "failed_to_register_code"
    end

    it "expects to fail if Rails.application.secrets haven't been configured" do
      allow(Ticket).to receive_messages(:disable_register_code => false)
      stub_invalid_eventbrite_secrets

      expect(Net::HTTP).to_not receive(:post_form)
      ticket = create(:ticket)

      expect(ticket.register_discount_code).to be_falsey
      expect(ticket.report).to match /.+secrets\.yml.+/
      expect(ticket.status).to eq "failed_to_register_code"
    end
  end
end
