class EpisodesController < ApplicationController

  def create
    @ac = ApiConnector.new
    episodes = @ac.get_episodes(params[:remote_id])
    episodes.each do |episode|
      name = episode.elements["EpisodeName"].text
      overview = episode.elements["Overview"].text
      name.nil? ? name = "This episode has no name" : name
      Episode.create!(:name => name, :overview => overview, :series_id => params[:remote_id])
    end
    redirect_to "/series/show"
  end
end
