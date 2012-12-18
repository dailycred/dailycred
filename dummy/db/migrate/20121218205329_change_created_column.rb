class ChangeCreatedColumn < ActiveRecord::Migration
  def change
    change_column :users, :created, :datetime
  end
end
