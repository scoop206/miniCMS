class AddRoleIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :user_role_id, :integer
    User.reset_column_information
  end

  def self.down
    remove_column :users, :user_role_id
  end
end
