class CreateCommunityHosts < ActiveRecord::Migration[5.0]
  def change
    create_table :community_hosts do |t|
      t.integer :community_id
      t.integer :host_id

      t.timestamps
    end
  end
end
