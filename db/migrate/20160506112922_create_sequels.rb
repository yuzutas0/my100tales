class CreateSequels < ActiveRecord::Migration
  def change
    create_table :sequels do |t|
      t.text :content
      t.integer :view_number, default: 0, null: false, index: true
      t.references :tale, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
