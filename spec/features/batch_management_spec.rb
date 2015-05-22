require 'rails_helper'

RSpec.feature "Batch management", type: :feature do
  scenario "User gets the login page with error when not logged in" do
    visit "/"
    expect(page).to have_selector('h1', text: "Login")
    expect(page).to have_selector('div.flash_notification')
  end
end
