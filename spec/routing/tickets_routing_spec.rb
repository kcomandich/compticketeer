require 'rails_helper'

describe TicketsController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect({ :get => "/tickets" }).to route_to(:controller => "tickets", :action => "index")
    end

    it "recognizes and generates #new" do
      expect({ :get => "/tickets/new" }).to route_to(:controller => "tickets", :action => "new")
    end

    it "recognizes and generates #show" do
      expect({ :get => "/tickets/1" }).to route_to(:controller => "tickets", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      expect({ :get => "/tickets/1/edit" }).to route_to(:controller => "tickets", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      expect({ :post => "/tickets" }).to route_to(:controller => "tickets", :action => "create") 
    end

    it "recognizes and generates #update" do
      expect({ :put => "/tickets/1" }).to route_to(:controller => "tickets", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      expect({ :delete => "/tickets/1" }).to route_to(:controller => "tickets", :action => "destroy", :id => "1") 
    end
  end
end
