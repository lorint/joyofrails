require "rails_helper"

RSpec.describe "AdminUser sessions", type: :system do
  it "signs in admin_user" do
    admin_user = FactoryBot.create(:admin_user)

    visit new_admin_users_session_path

    fill_in "Email", with: admin_user.email
    fill_in "Password", with: "password"

    click_button "Sign in"

    expect(page).to have_text("Signed in successfully.")

    expect(page).to have_text(admin_user.email)
  end
end
