class AddAdminUser < ActiveRecord::Migration
  
  def self.up
    
    user_role = UserRole.find_by_name("super")
    
    User.create(  :login => "admin",
                  :name => "admin",
                  :email => "",
                  :password => "foobar",
                  :password_confirmation => "foobar",
                  :user_role => user_role)                  
  end

  def self.down
   User.find_by_login(admin).destroy
  end
end
