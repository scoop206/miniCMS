class User < ActiveRecord::Base
  
  belongs_to :user_role
  validates_presence_of :login, :user_role_id
  
  def super?
    user_role.name == "super"
  end
  
  def basic?
    user_role.name == "basic"
  end
  
  acts_as_authentic do |c|
    c.validate_email_field = false
  end
end
