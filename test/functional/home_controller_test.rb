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
    get :page_that_does_not_exist, :site => sites(:foo_site1).id
    assert_response :missing
  end
  
  test "User receives 404 error when they try to hit a view that hasn't been associated with this site but is associated with another" do
    get :newsletter, :site => sites(:foo_site2).id
    assert_response :missing
  end
  
  test "a page successfully loads when the user goes to the root of the site" do
    get :index
    assert_response :success
  end
  
  test "getting to the foo_site2 index page wich has been mapped to the foo_site1 index page" do
    get :index, :site => "foo_site2"
    assert_response 200
  end
  
  test "we default to the foo_site1 site if the one we enter on query string isn't valid" do
    get :index, :site => "foo_site2t"
    assert_response 200
  end
  
end
