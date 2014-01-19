class SeriesUpdater

  def self.execute(remote_id)
    series = Series.find_by_remote_id(remote_id)
    series_update = ApiConnector.new.get_series_update(remote_id)
    parsed_series_update = REXML::Document.new(series_update)
    name = parsed_series_update.elements["//SeriesName"].text
    overview = parsed_series_update.elements["//Overview"].try(:text)
    series.update_attributes(name: name, overview: overview, last_remote_update: last_remote_update(remote_id))
  end

  private

  def self.last_remote_update(remote_id)
    series = Series.find_by_remote_id(remote_id)
    time_update = ApiConnector.new.retrieve_updates(series.last_remote_update)
    time_update = REXML::Document.new(time_update)
    time_update.elements["//Time"].text()
  end
end