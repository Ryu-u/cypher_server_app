class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.string :content, null: false

      t.timestamps
    end

    add_index :tags, :content, name: 'tags_unique_index'
  end
end
