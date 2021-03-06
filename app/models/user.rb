class User < ActiveRecord::Base
  has_many :user_episodes
  has_many :episodes, through: :user_episodes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  def has_watched?(episode_id)
    return false unless UserEpisode.where(user_id: self.id, episode_id: episode_id).any?
    return true
  end

  def has_watched(episode_id)
    UserEpisode.create(user_id: self.id, episode_id: episode_id)
  end
end
