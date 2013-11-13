class CreateUserEpisodes < ActiveRecord::Migration
  def change
    create_table :user_episodes do |t|
      t.belongs_to :user
      t.belongs_to :episode
    end
  end
end
