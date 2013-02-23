require 'spec_helper'

describe "/series/select_for_show.html.erb" do

  it "lists all remotely found series" do
    @user = FactoryGirl.create(:user, :email => "tom.lauwyck@gmail.com", :admin => true)

    @series_array = FactoryGirl.create(:series, :name => "Series 1")

    visit "/users/sign_in"
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "Sign in"
    visit "/admin_config/show"
    click_link "Copy over a series from thetvdb.com"
    fill_in "name", :with => "the simpsons"
    click_button "Search"

    page.should have_content "The Simpsons"
    page.should have_content "Jessica Simpson's The Price of Beauty"
    save_and_open_page


    #page.should have_content "Series 1"
  end
end
