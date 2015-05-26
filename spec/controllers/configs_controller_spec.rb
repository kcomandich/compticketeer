require 'rails_helper'

describe ConfigsController do

  before :each do
    login_as_admin
  end

  describe "with invalid configuration" do
    it "expects to display errors" do
      stub_invalid_eventbrite_config
      get :show
      expect(flash[:error]).to_not be_blank
    end
  end
end
