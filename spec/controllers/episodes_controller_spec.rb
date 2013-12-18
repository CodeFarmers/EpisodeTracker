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
          FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/1212/all/en.zip", :body => File.open(Rails.root.join("spec/data/en-stripped.zip")))
          post :create, :remote_id => @series.remote_id
          @episodes = Episode.all
        end

        let(:first_episode) { @episodes.first }
        subject { first_episode }

        it "should redirect to the episode index for the series" do
          response.should redirect_to series_episodes_path(@series)
        end

        its(:name) { should == "This episode has no name" }

        it "should create all remotely found episodes" do
          Episode.count.should == 4
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

          let(:episode_with_attrs) { @episodes[3] }
          subject { episode_with_attrs }
          its(:name) { should == "Minstrel Krampus" }
          its(:series_id) { should == 1212 }
          its(:season) { should == 9 }
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

    it_behaves_like "a get action", :index, {params: {series_id: 1}}

    before(:each) do
      @series = FactoryGirl.create(:series)
      @episode1 = @series.episodes.create(name: "De aflevering", overview: "Het overzicht", season: 1)
    end

    context "for an authenticated user" do

      it "should be rendered for an admin" do
        login_admin
        get :index, :series_id => @series
        response.should render_template("index")
      end

      context "for a regular user" do


        let(:series) { FactoryGirl.create(:series) }
        let(:other_user) { FactoryGirl.create(:user) }
        before(:each) do
          @episode2 = series.episodes.create(name: "De aflevering2", overview: "Het overzicht", season: 2)
          @episode1 = series.episodes.create(name: "De aflevering", overview: "Het overzicht", season: 1)
          @episode3 = series.episodes.create(name: "De aflevering3", overview: "Het overzicht", season: 1)
          login_user
          UserEpisode.create(user_id: @current_user.id, episode_id: @episode1.id)
          UserEpisode.create(user_id: @current_user.id, episode_id: @episode3.id)
          UserEpisode.create(user_id: other_user.id, episode_id: @episode2.id)
          get :index, :series_id => series
        end


        it { should render_template("index") }

        it "should show the series name" do
          response.body.should have_content("This is the episode list for #{series.name}")
        end

        it "should contain the name of the episodes" do
          response.body.should have_content(series.episodes.first.name)
          response.body.should have_content(series.episodes.second.name)
        end

        it "should be grouped by season and sorted" do
         @episodes = assigns(:episodes_grouped_by_season)
         @episodes[0].should == [1, [@episode1, @episode3] ]
         @episodes[1].should == [2, [@episode2] ]
        end

        it "should assign the user_episodes" do
          user_episodes = assigns(:user_episodes)
          user_episodes[@episode1.id].should eq(@episode1.user_episodes.first)
          user_episodes[@episode3.id].should eq(@episode3.user_episodes.first)
        end

        it "should only assign the user_episodes for the current user" do
          user_episodes = assigns(:user_episodes)
          user_episodes[@episode2.id].should be_nil
        end
      end


      #context "pagination"
      #
      #  let(:series) { FactoryGirl.create(:series) }
      #
      #  it "will not paginate when there are less than 10 episodes" do
      #    9.times do |i|
      #      series.episodes.create(name: "De aflevering#{i}", overview: "Het overzicht")
      #    end
      #    login_user
      #    get :index, :series_id => series
      #    response.body.should_not have_selector("div.pagination")
      #  end
      #
      #  it "will paginate when there are more than 10 episodes" do
      #    11.times do |i|
      #      series.episodes.create(name: "De aflevering#{i}", overview: "Het overzicht")
      #    end
      #    login_user
      #    get :index, :series_id => series
      #    response.body.should have_selector("div.pagination")
      #  end
    end
  end
end