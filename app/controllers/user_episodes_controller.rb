class UserEpisodesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, :only => [ :create, :destroy ]

  def create
    @user_episode = current_user.has_watched(params[:episode_id])
  end

  def destroy
    ap "user_id: #{current_user.id}"
    ap "episode_id: #{params[:id]}"
    ap UserEpisode.where(user_id: current_user.id, episode_id: params[:id])
    destroyed = UserEpisode.where(user_id: current_user.id, episode_id: params[:id]).destroy_all
    ap destroyed.first.class
    @user_episode = destroyed.first
  end
end