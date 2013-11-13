class Episode < ActiveRecord::Base
  belongs_to :series
  has_many :user_episodes
  has_many :users, through: :user_episodes
  validates_presence_of :name
  attr_accessible :name, :overview, :series_id, :season
end

