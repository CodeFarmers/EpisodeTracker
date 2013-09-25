require 'spec_helper'

describe SeriesController do
  render_views

  describe "GET 'search'" do

    it "should work for logged in users" do
      login_user
      get :search
      response.should render_template "series/search"
    end

    it "should redirect to the sign in page if not logged in" do
      get :search
      response.should redirect_to new_user_session_path
    end

    it "should render the title" do
      login_user
      get :search
      response.body.should have_content("Try the search box below to find a series")
    end

    it "should render the search form" do
      login_user
      get :search
      response.body.should have_selector("form")
    end
  end

  describe "GET index" do

    it "should query the model for the needed results" do
      name = "The Simpsons"
      post :search, :name => name
      Series.should_receive(:search).with(name)
    end

    it "should show the returned results" do
      post :search, :name => "The Simpsons"
      response.should have_content("The Simpsons")
    end
  end
end
