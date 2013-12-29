require 'spec_helper'

describe SeriesController do
  render_views

  describe "GET 'search'" do

    it_behaves_like "authentication required", :search, method: "GET"

    it "should work for logged in users" do
      login_user
      get :search
      response.should render_template "series/search"
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

    it_behaves_like "authentication required", :index, method: "GET"

    let(:series) { FactoryGirl.create(:series) }
    let!(:episode) { FactoryGirl.create(:episode, name: 'episode', series_id: series.remote_id) }

    it "should return JS" do
      xhr :get, :index, :search => "the simpsons"
      response.content_type[0..14].should == Mime::JS
    end

    it "should query the model for the needed results" do
      login_user
      Series.should_receive(:search).with(series.name).and_return([series])
      xhr :get, :index, :search => series.name
    end

    it "should show the returned results" do
      login_user
      xhr :get, :index, :search => series.name
      response.body.should have_content(series.name)
    end

    it "should render the 'not found' partial when no series are returned" do
      login_user
      xhr :get, :index, :search => "qmsldkf"
      response.body.should include "Your search did not return any results"
    end
  end
end
