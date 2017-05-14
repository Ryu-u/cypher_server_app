class CreateCommunityHosts < ActiveRecord::Migration[5.0]
  def change
    create_table :community_hosts do |t|
      t.integer :community_id, null: false
      t.integer :host_id, null: false

      t.timestamps
    end

    add_index :communities, [:community_id, :host_id], unique: true, name: 'communityhosts_unique_index'
  end
end
