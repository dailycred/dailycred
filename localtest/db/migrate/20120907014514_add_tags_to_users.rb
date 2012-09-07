class AddTagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tags, :text
    add_column :users, :referred, :text
  end
end
