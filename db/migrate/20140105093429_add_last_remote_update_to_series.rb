class AddLastRemoteUpdateToSeries < ActiveRecord::Migration
  def change
    add_column :series, :last_remote_update, :string
    Series.update_all last_remote_update: "1341144000"
    change_column :series, :last_remote_update, :string, null: false
  end
end
