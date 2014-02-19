require 'spec_helper'
include XmlTestHelpers
include UpdateHelper


describe SeriesUpdater do


  subject { SeriesUpdater }

  before { ActiveRecord::Base.connection.execute("insert into updates (last_updated_at) values ('1362939961')") }

  it { should respond_to(:execute) }

  describe "execute" do

    let!(:series) { FactoryGirl.create(:series, remote_id: 71663) }
    let(:existing_episode) { FactoryGirl.create(:episode, remote_id: 2, series: series)}
    let(:last_updated_at) { '1362939961' }

    before do
      response = XmlTestHelpers.get_text_from_file("spec/data/update_list.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/Updates.php?type=all&time=#{last_updated_at}", :body => response)
      series_update = XmlTestHelpers.get_text_from_file('spec/data/series_update.xml')
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/#{series.remote_id}/en.xml", body: series_update)
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/273979/en.xml", body: "")
      episode_update = XmlTestHelpers.get_text_from_file('spec/data/episode_update.xml')
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/episodes/#{existing_episode.remote_id}/en.xml", body: episode_update)
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/episodes/4/en.xml", body: episode_update)
    end

    it "should set the new last updated time" do
      SeriesUpdater.execute
      UpdateHelper.last_updated_at.should == '1389028696'
    end

    it "should update the series information if it exists" do
      SeriesUpdater.execute
      series.reload.name.should == "The Simpsonsupdated"
      series.reload.overview.should == "new overview"
    end

    it "should ignore the series if it does not yet exist" do
      lambda do
        SeriesUpdater.execute
      end.should_not change(Series, :count)
    end

    context "if the episode exists" do


      it "should update the episode information" do
        SeriesUpdater.execute
        existing_episode.reload.name.should == "The Ceremony"
        existing_episode.overview.should == "A sacred ceremony"
        existing_episode.series_id.should == series.remote_id
        existing_episode.season.should == 1
        existing_episode.air_date.should == Date.new(1995, 9, 19)
      end
    end

    context "if the episode does not exist" do
      context "if the series exists" do

        let!(:series_for_episode) { FactoryGirl.create(:series, remote_id: 333)}

        it "should create the episode" do
          lambda do
            SeriesUpdater.execute
          end.should change(Episode, :count).by(1)
        end

        it "should have created the episode with the correct params" do
          SeriesUpdater.execute
          episode = Episode.where(remote_id: 4).first
          episode.name.should == "The Ceremony"
          episode.overview.should == "A sacred ceremony"
          episode.series_id.should == series_for_episode.remote_id
          episode.season.should == 1
          episode.air_date.should == Date.new(1995, 9, 19)
        end
      end

      context "if the series does not exist" do
        it "should ignore the episode" do
          Episode.delete_all
          lambda do
            SeriesUpdater.execute
          end.should_not change(Episode, :count)
        end
      end
    end
  end
end