class UserEpisodesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, :only => [ :create, :destroy ]

  def create
    @user_episode = current_user.has_watched(params[:episode])
  end

  def destroy
    #destroyed = UserEpisode.where(user_id: current_user.id, episode_id: params[:id]).destroy_all
    #@user_episode = destroyed.first

    ##If record belongs to user checken!!
    @user_episode = UserEpisode.destroy(params[:id])
  end
end