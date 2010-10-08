require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
require 'home_controller'

# re-raise errors caught by the controller
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < ActionController::TestCase
  
  def setup
    @controller = HomeController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  test "User receives 404 error when they try to hit a view that hasn't been associated with any site" do
    get :page_that_does_not_exist, :site => sites(:digitu).id
    assert_response :missing
  end
  
  test "User receives 404 error when they try to hit a view that hasn't been associated with this site but is associated with another" do
    get :newsletter, :site => sites(:digituplus).id
    assert_response :missing
  end
  
  test "a page successfully loads when the user goes to the root of the site" do
    get :index
    assert_response :success
  end
  
  test "getting to the digituplus index page wich has been mapped to the digitu index page" do
    get :index, :site => "digituplus"
    assert_response 200
  end
  
  test "we default to the digitu site if the one we enter on query string isn't valid" do
    get :index, :site => "digituplust"
    assert_response 200
  end
  
end
