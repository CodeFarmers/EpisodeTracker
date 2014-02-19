class SeriesUpdater
  extend UpdateHelper

  def self.execute
    update_info = REXML::Document.new(ApiConnector.new.retrieve_updates(last_updated_at))
    UpdateHelper.last_updated_at = update_info.elements["//Time"].text

    series_ids = []
    update_info.elements.each("//Series") { |element| series_ids << element.text }
    series_ids.each do |remote_id|
      series = Series.where(remote_id: remote_id).first
      series_update = ApiConnector.new.get_series_update(remote_id)
      parsed_series_update = REXML::Document.new(series_update)
      name = parsed_series_update.elements["//SeriesName"].try(:text)
      overview = parsed_series_update.elements["//Overview"].try(:text)
      if series
        series.update_attributes(name: name, overview: overview)
      end
    end

    episode_ids = []
    update_info.elements.each("//Episode") { |element| episode_ids << element.text }
    episode_ids.each do |remote_id|
      episode = Episode.where(remote_id: remote_id).first
      episode_update = ApiConnector.new.get_episode_update(remote_id)
      parsed_episode_update = REXML::Document.new(episode_update)

      series_id = parsed_episode_update.elements["//seriesid"].try(:text)
      name = parsed_episode_update.elements["//EpisodeName"].try(:text)
      overview = parsed_episode_update.elements["//Overview"].try(:text)
      season = parsed_episode_update.elements["//SeasonNumber"].try(:text)
      air_date = parsed_episode_update.elements["//FirstAired"].try(:text)

      if episode
        episode.update_attributes(name: name, overview: overview, season: season, air_date: air_date)
      elsif Series.where(remote_id: series_id).any?
        remote_id = parsed_episode_update.elements["//id"].try(:text)
        Episode.create!(name: name, overview: overview, series_id: series_id, season: season, air_date: air_date, remote_id: remote_id)
      end
    end
  end
end