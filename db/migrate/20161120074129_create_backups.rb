class CreateBackups < ActiveRecord::Migration
  def change
    create_table :backups do |t|
      t.string :filename, null: false, unique: true
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
