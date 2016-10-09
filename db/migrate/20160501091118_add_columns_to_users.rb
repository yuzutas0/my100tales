class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, null: false, default: ''
    add_column :users, :timezone, :string, null: false, deafult: TZInfo::Timezone.get('Etc/GMT').identifier
  end
end
