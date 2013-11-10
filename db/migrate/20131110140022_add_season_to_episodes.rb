class AddSeasonToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :season, :integer
  end
end
