class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :key_name, index: true, null: false
      t.string :value, index: true, null: false
      t.integer :view_number, default: 0, null: false, index: true
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :scores, [:view_number, :user_id], unique: true
    add_index :scores, [:key_name, :value, :user_id], unique: true
  end
end
