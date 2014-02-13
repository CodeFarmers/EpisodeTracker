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
      if Series.where(remote_id: remote_id)
        update_series_info
      else
        create_series
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