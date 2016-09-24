class CreateBikes < ActiveRecord::Migration[5.0]
  def change
    create_table :bikes do |t|
      t.integer :bike_index_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
