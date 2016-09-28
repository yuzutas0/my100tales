class CreateSearches < ActiveRecord::Migration
  def change
    create_table :search_conditions do |t|
      t.string :name
      t.text :query_string, null: false
      t.boolean :save_flag, default: false, null: false
      t.references :user, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
