require 'spec_helper'

describe Episode do

  it { should belong_to(:series) }
  it { should have_many(:users).through(:user_episodes) }
  it { should validate_presence_of(:name) }
  it { should respond_to(:season) }
  it { should respond_to(:air_date) }

  before { @series = Series.new(:name => "Arrested Development", :remote_id => "123") }

  it "should set the correct series_id on creation" do
    episode = @series.episodes.new(:name => "test")
    episode.series_id.should == @series.remote_id
  end
end
