class CreateTaleTagRelationships < ActiveRecord::Migration
  def change
    create_table :tale_tag_relationships do |t|
      t.references :tale, index: true, foreign_key: true, null: false
      t.references :tag, index: true, foreign_key: true, null: false
    end

    add_index :tale_tag_relationships, [:tale_id, :tag_id], unique: true
  end
end
