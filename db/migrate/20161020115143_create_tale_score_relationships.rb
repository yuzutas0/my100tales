class CreateTaleScoreRelationships < ActiveRecord::Migration
  def change
    create_table :tale_score_relationships do |t|
      t.references :tale, index: true, foreign_key: true, null: false
      t.references :score, index: true, foreign_key: true, null: false
    end

    add_index :tale_score_relationships, [:tale_id, :score_id], unique: true
  end
end
