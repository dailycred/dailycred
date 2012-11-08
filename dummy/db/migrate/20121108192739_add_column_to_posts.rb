class AddColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :created, :timestamp
  end
end
