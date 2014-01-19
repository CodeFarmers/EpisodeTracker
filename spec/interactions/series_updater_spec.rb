require 'spec_helper'
include XmlTestHelpers

describe SeriesUpdater do

  subject { SeriesUpdater }
  it { should respond_to(:execute) }

  let(:series) { FactoryGirl.create(:series) }

  describe "execute" do

    it "should download the latest information" do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get,
                           "http://thetvdb.com/api/Updates.php?type=all&time=#{series.last_remote_update}",
                           :body => response)
      update_response = XmlTestHelpers.get_text_from_file("spec/data/series_update.xml")

      ApiConnector.any_instance.should_receive(:get_series_update).with(series.remote_id).and_return(update_response)
      SeriesUpdater.execute(series.remote_id)
    end

    it "should update the series information" do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/Updates.php?type=all&time=#{series.last_remote_update}", :body => response)
      update_response = XmlTestHelpers.get_text_from_file("spec/data/series_update.xml")
      FakeWeb.register_uri(:get, "http://thetvdb.com/api/4F5EC797A9F93512/series/#{series.remote_id}/en.xml", :body => update_response)

      SeriesUpdater.execute(series.remote_id)
      series.reload.name.should == "The Simpsonsupdated"
      series.overview.should == "new overview"
      series.last_remote_update.should == "1389028696"
    end
  end
end