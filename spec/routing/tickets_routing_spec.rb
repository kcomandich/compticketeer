require 'rails_helper'

describe TicketsController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect({ :get => "/tickets" }).to route_to(:controller => "tickets", :action => "index")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/tickets/1" }).to route_to(:controller => "tickets", :action => "show", :id => "1")
    end
  end
end
