def create_user
  @billy = User.create(  :login => "billy",
                      :name => "Billy Corgan",
                      :email => "billy@corgan.com",
                      :password => "foobar",
                      :password_confirmation => "foobar",
                      :user_role => user_roles(:super))
end
