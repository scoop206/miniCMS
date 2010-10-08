class AddRoleAssociationsToUsers < ActiveRecord::Migration
  def self.up
    User.find(:all).each do |user|
      user.user_role = UserRole.find_by_name("super")
      user.save!
    end
  end

  def self.down
  end
end
