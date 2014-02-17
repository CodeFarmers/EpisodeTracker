class SeriesUpdater
  extend UpdateHelper

  def self.execute
    update_info = REXML::Document.new(ApiConnector.new.retrieve_updates(last_updated_at))
    puts update_info

    UpdateHelper.last_updated_at = update_info.elements["//Time"].text

    series_ids = []
    update_info.elements.each("//Series") { |element| series_ids << element.text }
    ap series_ids
    series_ids.each do |remote_id|
      series = Series.where(remote_id: remote_id).first
      series_update = ApiConnector.new.get_series_update(remote_id)
      parsed_series_update = REXML::Document.new(series_update)
      name = parsed_series_update.elements["//SeriesName"].try(:text)
      overview = parsed_series_update.elements["//Overview"].try(:text)
      if series
        series.update_attributes(name: name, overview: overview)
      else
        remote_id = parsed_series_update.elements["//id"].try(:text)
        Series.create(name: name, overview: overview, remote_id: remote_id)
      end
    end



    episodes = []
    update_info.elements.each("//Episode") { |element| episodes << element.text }
    ap episodes

    #series = Series.find_by_remote_id(remote_id)
    #series_update = ApiConnector.new.get_series_update(remote_id)
    #parsed_series_update = REXML::Document.new(series_update)
    #name = parsed_series_update.elements["//SeriesName"].text
    #overview = parsed_series_update.elements["//Overview"].try(:text)
    #series.update_attributes(name: name, overview: overview, last_remote_update: last_remote_update(remote_id))
  end

end