require "rails_helper"

RSpec.describe "Searches", type: :system do
  it "show search results" do
    Page.create!(request_path: "/pwa-showcase")

    visit root_path

    find("#search-button").click

    fill_in :query, with: "Progressive Web Apps"

    within "dialog" do
      expect(page).to have_content("Progressive Web Apps on Rails Showcase")
    end

    click_link "Progressive Web Apps on Rails Showcase"

    within "main header" do
      expect(page).to have_content("Progressive Web Apps on Rails Showcase")
    end
  end
end