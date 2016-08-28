class CreateTaleTagRelationships < ActiveRecord::Migration
  def change
    create_table :tale_tag_relationships do |t|
      t.references :tale, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true
    end
  end
end
