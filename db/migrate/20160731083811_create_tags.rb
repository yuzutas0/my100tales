class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :view_number, default: 0, null: false, index: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
