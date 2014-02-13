class RemoveLastRemoteUpdateFromSeries < ActiveRecord::Migration
  def up
    remove_column :series, :last_remote_update
  end

  def down
    add_column :series, :last_remote_update, :string
  end
end
