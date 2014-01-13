class SeriesUpdater

  def self.execute(series_id)

    ac = ApiConnector.new
    update = ac.get_series_update(series_id)
    ##TODO: extract the contents of update to update the series with
  end
end