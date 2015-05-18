require 'rails_helper'

describe TicketKindsController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect({ :get => "/ticket_kinds" }).to route_to(:controller => "ticket_kinds", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/ticket_kinds/new" }).to route_to(:controller => "ticket_kinds", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/ticket_kinds/1" }).to route_to(:controller => "ticket_kinds", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/ticket_kinds/1/edit" }).to route_to(:controller => "ticket_kinds", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/ticket_kinds" }).to route_to(:controller => "ticket_kinds", :action => "create") 
    end

    it "recognizes and generates #update" do
      expect({ :put => "/ticket_kinds/1" }).to route_to(:controller => "ticket_kinds", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/ticket_kinds/1" }).to route_to(:controller => "ticket_kinds", :action => "destroy", :id => "1") 
    end
  end
end
