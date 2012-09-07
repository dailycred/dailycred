class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :text
  end
end
