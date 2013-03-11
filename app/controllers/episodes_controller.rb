class EpisodesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :only => [:create]

  def create
    @ac = ApiConnector.new
    episodes = @ac.get_episodes(params[:remote_id])
    episodes.each do |episode|
      name = episode.elements["EpisodeName"].text
      overview = episode.elements["Overview"].text
      name.nil? ? name = "This episode has no name" : name
      Episode.create!(:name => name, :overview => overview, :series_id => params[:remote_id])
    end
    @series = Series.where(:remote_id => params[:remote_id]).first
    redirect_to series_episodes_path(@series)
  end

  def index
  end
end
