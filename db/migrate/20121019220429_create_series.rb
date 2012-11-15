class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.string  :name
      t.text    :overview
      t.string  :remote_id

      t.timestamps
    end
  end
end
