require 'spec_helper'
include XmlTestHelpers
include UpdateHelper


describe SeriesUpdater do


  subject { SeriesUpdater }

  before { ActiveRecord::Base.connection.execute("insert into updates (last_updated_at) values ('1362939961')") }

  it { should respond_to(:execute) }

  describe "execute" do

    let!(:series) { FactoryGirl.create(:series, remote_id: 71663) }
    let(:last_updated_at) { '1362939961' }

    before do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/Updates.php?type=all&time=#{last_updated_at}", :body => response)
      series_update = XmlTestHelpers.get_text_from_file('spec/data/series_update.xml')
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/#{series.remote_id}/en.xml", body: series_update)
    end

    it "should set the new last updated time" do
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/273979/en.xml", body: "")

      SeriesUpdater.execute
      UpdateHelper.last_updated_at.should == '1389028696'
    end

    it "should update the series information if it exists" do
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/273979/en.xml", body: "")

      SeriesUpdater.execute
      series.reload.name.should == "The Simpsonsupdated"
      series.reload.overview.should == "new overview"
    end

    it "should create the series if it does not yet exist" do
      unknown_series_update = XmlTestHelpers.get_text_from_file('spec/data/unknown_series_update.xml')
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/273979/en.xml", body: unknown_series_update)

      SeriesUpdater.execute

      unknown_series = Series.where(remote_id: 273979).first
      unknown_series.name.should == 'Hoeba!'
      unknown_series.overview.should == 'Snowverview'
    end

    it "should update the episode information" do

    end
  end
end