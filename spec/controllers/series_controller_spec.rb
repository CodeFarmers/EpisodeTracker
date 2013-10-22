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

    let(:series) { FactoryGirl.create(:series) }
    let!(:episode) { FactoryGirl.create(:episode, name: 'episode', series_id: series.remote_id) }

    it "should query the model for the needed results" do
      login_user
      Series.should_receive(:search).with(series.name).and_return([series])
      get :index, :search => series.name
    end

    it "should show the returned results" do
      login_user
      get :index, :search => series.name
      response.body.should have_content(series.name)
    end
  end
end
