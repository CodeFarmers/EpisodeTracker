class AddLastRemoteUpdateToSeries < ActiveRecord::Migration
  def change
    add_column :series, :last_remote_update, :date
    Series.update_all last_remote_update: "01/07/2012".to_date
  end
end
