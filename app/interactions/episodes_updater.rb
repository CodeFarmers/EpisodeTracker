class EpisodesUpdater

  def self.execute(remote_id)
    episode_update = ApiConnector.new.get_episode_update(remote_id)
    parsed_episode_update = REXML::Document.new(episode_update)

  end
end