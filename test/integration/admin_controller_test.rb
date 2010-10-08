require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
require File.join(File.dirname(__FILE__), 'login')

class AdminControllerTest < ActionController::IntegrationTest
  fixtures :all

  def setup
    create_user
    @user = User.find(:first)
    
    # login
    post "user_session", :user_session =>  { :login => 'billy', :password => 'foobar' }
  end


  def setup
    create_user
    @user = User.find(:first)
    
    # login
    post "user_session", :user_session =>  { :login => 'billy', :password => 'foobar' }
  end
  
  test "manage_notifications will create email_recipients with no garbage on name" do
    
    post    'manage_notifications', 
            :mail_list_id => mail_lists(:big_list).id, 
            :sites => { :id => sites(:digitu).id }, 
            :email_recipients => "foo@bar.com\r\nsusy@losy.com\r\nchocho@chachee.com",
            :commit => "yes"
            
    # assert we have an email recipient with the stripped down name
    susy = mail_lists(:big_list).mail_list_recipients.find(:first, :conditions => ["site_id = ? AND email_address = ?", sites(:digitu), "susy@losy.com"])
    assert !susy.nil?
  end
  
end
