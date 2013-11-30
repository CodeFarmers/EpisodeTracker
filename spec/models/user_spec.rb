require 'spec_helper'

describe User do
  before { @user = User.new(:email => "john.doe@gmail.com", :password => "123", :password_confirmation => "123", :remember_me => true) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:has_watched?) }
  it { should respond_to(:has_watched) }
  it { should have_many(:episodes).through(:user_episodes) }

  describe "has_watched?" do
    let(:user) { FactoryGirl.create(:user) }
    let(:episode) { FactoryGirl.create(:episode) }

    it "should return true if a user_episode was found" do
      UserEpisode.create(user_id: user.id, episode_id: episode.id)
      user.has_watched?(episode.id).should be_true
    end

    it "should return false if no user_episode was found" do
      user.has_watched?(episode.id).should be_false
    end
  end

  describe "has_watched" do
    let(:user) { FactoryGirl.create(:user) }
    let(:episode) { FactoryGirl.create(:episode) }

    it "should create a user_episode" do
      user.has_watched(episode.id)
      user.should have_watched(episode.id)
    end
  end
end
