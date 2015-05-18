require 'rails_helper'

describe TicketKindsController do

  before :each do
    login_as_admin
  end

  def create_record
    @record = create(:ticket_kind)
  end

  def create_records
    @records = [
      create(:ticket_kind),
      create(:ticket_kind),
    ]
  end

  describe "index" do
    it "expects to list ticket kinds" do
      TicketKind.destroy_all
      create_records
      get :index
      expect(response).to be_success
      expect(flash[:error]).to be_blank
      expect(assigns[:ticket_kinds]).to == @records
    end

    it "expects to list empty set" do
      get :index
      expect(response).to be_success
      expect(flash[:error]).to be_blank
      expect(assigns[:ticket_kinds]).to == []
    end
  end

  describe "new" do
    it "expects to display form" do
      get :new
      expect(response).to be_success
      expect(flash[:error]).to be_blank
    end
  end

  describe "create" do
    it "expects to succeed when given valid attributes" do
      attributes = attributes_for(:ticket_kind)
      post :create, :ticket_kind => attributes
      expect(response).to redirect_to(ticket_kind_path(assigns[:ticket_kind]))
      expect(assigns[:ticket_kind]).to be_valid
    end

    it "expects to fail when given invalid attributes" do
      attributes = attributes_for(:ticket_kind, :title => nil)
      post :create, :ticket_kind => attributes
      expect(response).to be_success
      expect(assigns[:ticket_kind]).to_not be_valid
    end
  end

  describe "show" do
    it "expects to succeed" do
      create_record
      get :show, :id => @record.id
      expect(response).to be_success
      expect(assigns[:ticket_kind]).to == @record
    end
  end

  describe "edit" do
    it "expects to succeed" do
      create_record
      get :edit, :id => @record.id
      expect(response).to be_success
      expect(assigns[:ticket_kind]).to == @record
    end
  end

  describe "update" do
    it "expects to succeed with valid attributes" do
      create_record
      put :update, :id => @record.id, :ticket_kind => @record.attributes
      expect(response).to redirect_to(ticket_kind_path(@record))
      expect(assigns[:ticket_kind]).to == @record
    end

    it "expects to fail with invalid attributes" do
      create_record
      put :update, :id => @record.id, :ticket_kind => { :title => nil }
      expect(response).to be_success
      expect(assigns[:ticket_kind]).to == @record
      expect(assigns[:ticket_kind].errors.full_messages.first).to =~ /title can't be blank/i
    end
  end

  describe "destroy" do
    it "expects to succeed" do
      create_record
      delete :destroy, :id => @record.id
      expect(response).to redirect_to(ticket_kinds_path)
      expect(TicketKind.exists?(@record.id)).to be_falsey
    end
  end

end
