class CreateTales < ActiveRecord::Migration
  def change
    create_table :tales do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.integer :view_number, default: 0, null: false, index: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :tales, [:view_number, :user_id], unique: true
  end
end
