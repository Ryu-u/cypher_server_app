class AddIndexToCommunityName < ActiveRecord::Migration[5.0]
  def change
    add_index :communities, :name, unique: true
  end
end
