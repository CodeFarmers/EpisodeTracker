class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string  :last_updated_at
    end
  end
end
