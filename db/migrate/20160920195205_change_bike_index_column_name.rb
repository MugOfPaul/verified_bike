class ChangeBikeIndexColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :bikes, :bike_index_id, :bike_index_uid
  end
end
