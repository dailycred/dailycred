class AlterColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :email
    add_column :users, :email, :string
  end
end
