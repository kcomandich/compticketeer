require 'rails_helper'

describe BatchesController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect({ get: "/batches" }).to route_to(controller: "batches", action: "index")
    end

    it "recognizes and generates #new" do
      expect({ get: "/batches/new" }).to route_to(controller: "batches", action: "new")
    end

    it "recognizes and generates #show" do
      expect({ get: "/batches/1" }).to route_to(controller: "batches", action: "show", id: "1")
    end

    it "recognizes and generates #create" do
      expect({ post: "/batches" }).to route_to(controller: "batches", action: "create")
    end

    it "recognizes and generates #destroy" do
      expect({ delete: "/batches/1" }).to route_to(controller: "batches", action: "destroy", id: "1")
    end
  end
end
