require 'test_helper'

class SiteVarsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_vars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_var" do
    assert_difference('SiteVar.count') do
      post :create, :site_var => { }
    end

    assert_redirected_to site_var_path(assigns(:site_var))
  end

  test "should show site_var" do
    get :show, :id => site_vars(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => site_vars(:one).to_param
    assert_response :success
  end

  test "should update site_var" do
    put :update, :id => site_vars(:one).to_param, :site_var => { }
    assert_redirected_to site_var_path(assigns(:site_var))
  end

  test "should destroy site_var" do
    assert_difference('SiteVar.count', -1) do
      delete :destroy, :id => site_vars(:one).to_param
    end

    assert_redirected_to site_vars_path
  end
end
