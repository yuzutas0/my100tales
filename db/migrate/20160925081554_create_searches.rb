class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.text :condition
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :searches, [:user_id, :condition], unique: true
  end
end
