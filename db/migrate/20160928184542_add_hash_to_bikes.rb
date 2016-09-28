class AddHashToBikes < ActiveRecord::Migration[5.0]
  def change
    add_column :bikes, :hash_code, :string
  end
end
