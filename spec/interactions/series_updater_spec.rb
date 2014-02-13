require 'spec_helper'
include XmlTestHelpers
include UpdateHelper

describe SeriesUpdater do

  subject { SeriesUpdater }

  before { ActiveRecord::Base.connection.execute("insert into updates (last_updated_at) values ('1362939961')") }

  it { should respond_to(:execute) }

  let(:series) { FactoryGirl.create(:series) }
  let(:last_updated_at) { '1362939961' }


  describe "execute" do

    it "should set the new last updated time" do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/Updates.php?type=all&time=#{last_updated_at}", :body => response)
      SeriesUpdater.execute
      UpdateHelper.last_updated_at.should == '1389028696'
    end

    it "should update the series information" do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/Updates.php?type=all&time=#{last_updated_at}", :body => response)
      update_response = XmlTestHelpers.get_text_from_file("spec/data/series_update.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/#{series.remote_id}/en.xml", :body => update_response)

      SeriesUpdater.execute
      series.reload.name.should == "The Simpsonsupdated"
      series.overview.should == "new overview"
    end

    it "should update the episode information" do

    end
  end
end