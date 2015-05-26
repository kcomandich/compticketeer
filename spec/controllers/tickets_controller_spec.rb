require 'rails_helper'

describe TicketsController do

  before :each do
    login_as_admin
  end

  def mock_ticket
    @mock_ticket ||= Ticket.new
  end

  describe "GET index" do
    it "assigns all tickets as @tickets" do
      allow(Ticket).to receive(:ordered).and_return([mock_ticket])
      get :index
      expect(assigns[:tickets]).to eq([mock_ticket])
    end
  end

  describe "GET show" do
    it "assigns the requested ticket as @ticket" do
      allow(Ticket).to receive(:find).with("37").and_return(mock_ticket)
      get :show, id: "37"
      expect(assigns[:ticket]).to equal(mock_ticket)
    end
  end

end
