class Episode < ActiveRecord::Base
  belongs_to :series
  has_many :user_episodes
  has_many :users, through: :user_episodes
  validates_presence_of :name
  attr_accessible :name, :overview, :series_id, :season

  def has_been_watched_by?(user)
    UserEpisode.where(user_id: user.id, episode_id: self.id).any?
  end
end

