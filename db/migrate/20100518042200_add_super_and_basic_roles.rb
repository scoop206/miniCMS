class AddSuperAndBasicRoles < ActiveRecord::Migration
  
  def self.roles
    %w{ super basic }
  end
  
  def self.up
    roles.each { |role| UserRole.create(:name => role) }
  end

  def self.down
    roles.each { |role| UserRole.find_by_name(role).destroy }
  end
end
