class AddRemoteIdToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :remote_id, :integer
  end
end
