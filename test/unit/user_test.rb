require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')

class UserTest < ActiveSupport::TestCase

def setup
  create_billy
end

test "can we add billy to a mail list?" do
  @billy.mail_lists << mail_lists(:big_list)
  assert @billy.mail_lists.first.name == "big_list"
end

test "can we get a list of the users on a mail list?" do
  @billy.mail_lists << mail_lists(:big_list)
  @billy.save!
  assert mail_lists(:big_list).users.first.login == "billy"
end

private

def create_billy
    @billy = User.new(  :login => "billy",
                        :name => "Billy Corgan",
                        :email => "billy@corgan.com",
                        :password => "foobar",
                        :password_confirmation => "foobar",
                        :user_role => user_roles(:super))
end

end
