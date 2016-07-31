class CreateTalesTags < ActiveRecord::Migration
  def change
    create_table :tales_tags do |t|
      t.references :tale, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true
    end
  end
end
