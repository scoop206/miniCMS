require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
require File.join(File.dirname(__FILE__), 'login')

class UsersTest < ActionController::IntegrationTest
  fixtures :all

  def setup
    create_user
    @user = User.find(:first)
    
    # login
    post "user_session", :user_session =>  { :login => 'billy', :password => 'foobar' }
  end
  
  test "do we have a user to test against" do
    assert @user.login == "billy"
  end
  
  test "should get to admin page" do
    
    get "admin"
    assert_response :success
    
  end
    
  
end
