class UserEpisodesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, :only => [ :create, :destroy ]

  def create
    @user_episode = current_user.has_watched(params[:episode])
  end

  def destroy
    if belongs_to_current_user(params[:id])
      @user_episode = UserEpisode.destroy(params[:id])
    else
      not_found
    end
  end

  private

  def belongs_to_current_user(id)
    UserEpisode.find(id).user_id == current_user.id
  end
end