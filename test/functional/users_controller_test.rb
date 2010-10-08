# require 'test_helper'
require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')

class UsersControllerTest < ActionController::TestCase
  
  def setup
    create_billy
    login_as_billy
  end
  
  test "do we have a user to test against" do
    assert @billy.name = "billy"
  end
  
  test "should get index and we should have a session established" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  # 
  # test "should create user" do
  #   assert_difference('User.count') do
  #     post :create, :login => 'tony', 
  #                   :name => 'Tony Hawk', 
  #                   :email => 'tony@hawk.com',
  #                   :password => 'foobar',
  #                   :password_confirmation => 'foobar' 
  #   end
  # 
  #   assert_redirected_to user_path(assigns(:user))
  # end

  # test "should show user" do
  #   get :show, :id => users(:one).to_param
  #   assert_response :success
  # end
  # 
  # test "should get edit" do
  #   get :edit, :id => users(:one).to_param
  #   assert_response :success
  # end
  # 
  # test "should update user" do
  #   put :update, :id => users(:one).to_param, :user => { }
  #   assert_redirected_to user_path(assigns(:user))
  # end
  # 
  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete :destroy, :id => users(:one).to_param
  #   end
  # 
  #   assert_redirected_to users_path
  # end
  
  private
  
  def create_billy
    @billy = User.new(  :login => "billy",
                        :name => "Billy Corgan",
                        :email => "billy@corgan.com",
                        :password => "foobar",
                        :password_confirmation => "foobar",
                        :user_role => user_roles(:super))
  end
  
  def login_as_billy
    post "user_session/create", :login => "billy", :password => "foobar"
  end
  
end
