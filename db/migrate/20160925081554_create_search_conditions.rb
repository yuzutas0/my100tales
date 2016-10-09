class CreateSearchConditions < ActiveRecord::Migration
  def change
    create_table :search_conditions do |t|
      t.string :name
      t.text :query_string, null: false
      t.boolean :save_flag, default: false, null: false
      t.integer :view_number, default: 0, null: false, index: true
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :search_conditions, [:view_number, :user_id], unique: true
  end
end
