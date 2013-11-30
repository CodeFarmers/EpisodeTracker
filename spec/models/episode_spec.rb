require 'spec_helper'

describe Episode do

  it { should belong_to(:series) }
  it { should have_many(:users).through(:user_episodes) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:season) }
  it { should respond_to(:has_been_watched_by?) }

  before { @series = Series.new(:name => "Arrested Development", :remote_id => "123") }

  it "should set the correct series_id on creation" do
    episode = @series.episodes.new(:name => "test")
    episode.series_id.should == @series.remote_id
  end

  describe "has_been_watched_by?" do
    let(:episode) {FactoryGirl.create(:episode) }
    let(:user) {FactoryGirl.create(:user) }

    it "should return false if no user_episode is found" do
      episode.has_been_watched_by?(user).should be_false
    end

    it "should return true if a user_episode is found" do
      UserEpisode.create(user_id: user.id, episode_id: episode.id )
      episode.has_been_watched_by?(user).should be_true
    end
  end
end
