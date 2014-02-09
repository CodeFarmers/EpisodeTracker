require 'spec_helper'

describe EpisodesUpdater do

  describe "::execute" do
    let!(:series) { FactoryGirl.create(:series) }

    let(:episode) { series.episodes.create(name: "De aflevering2", overview: "Het overzicht", series_id: series.id) }

    it "should get a list of episodes to update" do
      EpisodesUpdater.should_receive(:episodes_to_update)
      EpisodesUpdater.execute
    end

    it "should download the latest information" do
      response = XmlTestHelpers.get_text_from_file("spec/data/remote_id_found.xml")
      FakeWeb.register_uri(:get,
                           "http://thetvdb.com/api/Updates.php?type=all&time=#{episode.series.last_remote_update}",
                           :body => response)

      update_response = XmlTestHelpers.get_text_from_file("spec/data/episode_update.xml")
      ApiConnector.any_instance.should_receive(:get_episode_update).with(episode.remote_id).and_return(update_response)
      EpisodesUpdater.execute(episode.remote_id)
    end
  end
end