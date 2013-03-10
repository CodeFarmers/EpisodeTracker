require 'spec_helper'

describe EpisodesController do

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

        it "should redirect to the series controller show action" do
          response.should redirect_to series_path(@series)
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
end