# require 'test_helper'
require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')


class SitesControllerTest < ActionController::TestCase
    
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, :site => { }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, :id => sites(:digitu).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sites(:digitu).to_param
    assert_response :success
  end

  test "should update site" do
    put :update, :id => sites(:digitu).to_param, :site => { }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, :id => sites(:digitu).to_param
    end

    assert_redirected_to sites_path
  end
  
  test "should be able to add a pages_site association from different sites" do
    remove_all_pages_sites
    add_pages_site(pages(:index), sites(:digituplus), 1)
    add_pages_site(pages(:index), sites(:digitu), 2)
    add_pages_site(pages(:welcome), sites(:digitu), 3)
    add_pages_site(pages(:newsletter), sites(:digitu), 4)    
    add_pages_site(pages(:welcome), sites(:digituplus), 5)
    add_pages_site(pages(:newsletter), sites(:digituplus), 6)
  end
  
  test "that we can't associate a page that has aleady been associated with a site" do
    remove_all_pages_sites
    add_pages_site(pages(:index), sites(:digituplus), 1)
    add_pages_site(pages(:index), sites(:digitu), 2)
    
    post :associate_page, :page => {"id" => pages(:index).id}, :id => sites(:digituplus).id
    assert_response 302
    
    ps = PagesSite.find(:all)
    assert ps.count == 2
    
    a_ps = PagesSite.find(:first, :conditions => ["page_id = :page AND site_id = :site", {:page => pages(:index), :site => sites(:digituplus)} ])
    assert !a_ps.nil?
    
  end
  
  test "should be able to remove a pages association with a site" do
    ps = PagesSite.find(:first, :conditions => ["page_id = ? and site_id = ?", pages(:index), sites(:digitu)])
    assert !ps.nil?
    get :remove_page, :pages_site_id => ps.id, :id => sites(:digitu)
    assert_redirected_to edit_site_path(sites(:digitu))
    no_ps = PagesSite.find(:all, :conditions => ["page_id = ? and site_id = ?", pages(:index), sites(:digitu)])
    assert no_ps.empty?
  end
  
  test "quick_lookup_file_location when there is no page_source" do
    get :quick_lookup_file_location, :page_id => pages(:newsletter).id, :site_id => sites(:digitu).id
    assert_equal(@response.body, "{'location': '#{RAILS_ROOT}/app/views/digitu/newsletter.html.erb'};")        
  end
  
  test "quick_lookup_file_location where page source is self" do
    get :quick_lookup_file_location, :page_id => pages(:index).id, :site_id => sites(:digitu).id
    assert_equal(@response.body, "{'location': '#{RAILS_ROOT}/app/views/digitu/index.html.erb'};")
  end
  
  test "quick_lookup_file_location where page source is different" do
    get :quick_lookup_file_location, :page_id => pages(:index).id, :site_id => sites(:digituplus).id
    assert_equal(@response.body, "{'location': '#{RAILS_ROOT}/app/views/digitu/index.html.erb'};")
  end
  
  private
  
  def remove_all_pages_sites
    PagesSite.find(:all).each { |ps| ps.destroy }
  end
  
  def add_pages_site(page, site, count_should_be)
    
    post :associate_page, :page => {"id" => page.id}, :id => site.id
    assert_response 302
    
    ps = PagesSite.find(:all)
    assert ps.count == count_should_be
    
    a_ps = PagesSite.find(:first, :conditions => ["page_id = :page AND site_id = :site", {:page => page, :site => site} ])
    assert !a_ps.nil?
  end
end
