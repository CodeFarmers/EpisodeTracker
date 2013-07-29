require 'spec_helper'

describe EpisodesController do
  render_views

  describe "POST 'create'" do

    context "for an authenticated person" do

      context "who is a user" do

        it "should throw an error" do
          login_user
          expect { post :create, :remote_id => 0 }.to raise_error(CanCan::AccessDenied)
        end
      end

      context "who is an admin" do

        before(:each) do
          login_admin
          @series = FactoryGirl.create(:series, :remote_id => 1212)
          @ac = ApiConnector.new
          FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/1212/all/en.zip", :body => File.open(Rails.root.join("spec/data/en.zip")))
          post :create, :remote_id => @series.remote_id
          @episodes = Episode.first(2)
        end

        let(:first_episode) { @episodes.first }
        subject { first_episode }

        it "should redirect to the episode index for the series" do
          response.should redirect_to series_episodes_path(@series)
        end

        its(:name) { should == "This episode has no name" }

        its(:overview) { should be_nil }

        it "should create all remotely found episodes" do
          Episode.count.should == 148
        end

        it "should set the series_ids to the remote_id of the series" do
          @episodes.each do |episode|
            episode.series_id.should == @series.remote_id
          end
        end

        it "should not get the episodes if they are already present for the series" do
          post :create, :remote_id => @series.remote_id
          flash.now[:alert].should eq("It looks like you already have the episodes for that series!")
        end

        context "when the attributes are present" do

          let(:second_episode) { @episodes[1] }
          subject { second_episode }

          its(:name) { should == "Original Pilot" }
          its(:overview) { should include "Francine puts Roger on a diet." }
          its(:series_id) { should == 1212 }
        end
      end
    end

    context "for a non-authenticated user" do

      it "should redirect to the sign in page" do
        post :create, :remote_id => 0
        response.should redirect_to "/users/sign_in"
      end
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @series = FactoryGirl.create(:series)
    end

    it "should not be rendered for an unauthenticated user" do
      get :index, :series_id => @series
      response.should redirect_to new_user_session_path
    end

    context "for an authenticated user" do

      it "should be rendered for an admin" do
        login_admin
        get :index, :series_id => @series
        response.should render_template("index")
      end

      context "for a regular user" do


        let(:series) { FactoryGirl.create(:series) }
        before(:each) do
          @episode1 = series.episodes.create(name: "De aflevering", overview: "Het overzicht")
          @episode2 = series.episodes.create(name: "De aflevering2", overview: "Het overzicht")
          login_user
          get :index, :series_id => series
        end


        it { should render_template("index") }

        it "should show the series name" do
          response.body.should have_content("This is the episode list for #{series.name}")
        end

        it "should show the episodes list" do
          ap series
          ap series.episodes

          response.body.should have_selector("ul#episodes li")
        end

        it "should contain the name of the episodes" do
          response.body.should have_content(series.episodes.first.name)
          response.body.should have_content(series.episodes.second.name)
        end
      end

      context "pagination"

        let(:series) { FactoryGirl.create(:series) }

        it "will not paginate when there are less than 10 episodes" do
          9.times do |i|
            series.episodes.create(name: "De aflevering#{i}", overview: "Het overzicht")
          end
          login_user
          get :index, :series_id => series
          response.body.should_not have_selector("div.pagination")
        end

        it "will paginate when there are more than 10 episodes" do
          11.times do |i|
            series.episodes.create(name: "De aflevering#{i}", overview: "Het overzicht")
          end
          login_user
          get :index, :series_id => series
          ap response.body
          response.body.should have_selector("div.pagination")
        end
    end
  end
end