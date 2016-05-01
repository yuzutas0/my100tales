class CreateTales < ActiveRecord::Migration
  def change
    create_table :tales do |t|
      t.string :title
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
