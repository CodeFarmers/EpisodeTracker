class ChangeRemoteidToInteger < ActiveRecord::Migration
  def change
    change_column :series, :remote_id, :integer
  end
end
