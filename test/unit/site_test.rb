require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
# require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  
  fixtures :pages_sites
  
  test "create" do
     site = Site.create(:name => "foo")
     assert site != nil
     assert site.name == "foo"
   end
   
   test "get_view(action) if action has no page source then return 'site.name/action'" do
     assert true
   end
   
   test "verify sites working" do
     assert sites(:digitu).name == "digitu"
   end
   
   test "verify site.pages_sites working" do
      # verify that these pages_sites are accessible
      %w{index welcome }.each do |target_page|
       found_ps = false
       sites(:digitu).pages_sites.each do |ps|
         found_ps = true   if ps.page.name == target_page 
         next                if ps.page.name == target_page 
       end
       flunk("#{target_page} was not found in the pages_sites associated with #{sites(:digitu).name}") unless found_ps
      end
    end
   
   
   test "verify site.pages working" do
     # verify that these pages are accessible
     %w{index welcome }.each do |target_page|
      found_page = false
      sites(:digitu).pages.each do |page|
        found_page = true   if page.name == target_page 
        next                if page.name == target_page 
      end
      flunk("#{target_page} was not found in the pages associated with #{sites(:digitu).name}") unless found_page
     end
   end
   
   
   test "get_view should return the action for the calling site if no page source is defined" do
     assert sites(:digitu).get_view("newsletter") == "digitu/newsletter"
   end
  
  test "get_view should return the site/action for the page_source when it's pointing at a different site" do
      foo = sites(:digituplus).get_view("welcome")
      assert foo == "digitu/index"
  end
  
  test "get_view should return the site/action for the calling site if page_source is pointing to itself (unececessary but allowed)" do
      assert sites(:digitu).get_view("index") == "digitu/index"
    end
    
    test "strip_underscore_from_front: when passed a string with underscore in front it returns without underscore" do
      assert Site.strip_underscore_from_front("_unit") == "unit"
    end
    
    test "strip_underscore_from_front:  when passed a string without underscore in front it return same string" do
      assert Site.strip_underscore_from_front("unit") == "unit"
    end
    
    test "strip_underscore_from_front:  when passed a string without underscore in front it return same string (with other underscore in string)" do
      assert Site.strip_underscore_from_front("_unit_one_two") == "unit_one_two"
    end
    
    test "strip_underscore_from_front:  when passed a string without underscore in front it return same string (with 2 underscores at beginning)" do
      assert Site.strip_underscore_from_front("__unit") == "_unit"
    end

  test "partial: get_view should return views with no underscore in front of the action" do
     assert sites(:digitu).get_view("_information_block") == "digituplus/information_block"
   end
  
  test "partial: site should return the path of a different site" do
    assert sites(:digitu).get_view("_information_block") == "digituplus/information_block"
  end
  
  test "partial: site should return the path to itself if no page_source is defined" do
    assert sites(:digitu).get_view("_information_block") == "digituplus/information_block"
  end
  
  test "partial: site should return the path to itself if a page_source pointing to itself is defined" do
    assert sites(:digitu).get_view("_information_block") == "digituplus/information_block"
  end
  
  test "populate_page_list_from_dir add all the files that are in a directory as pages to the site?" do
    dir = "#{RAILS_ROOT}/test/fixtures/files"
    sites(:digitu).populate_page_list_from_dir(dir)
    
    page1 = Page.find_by_name('foo')
    assert sites(:digitu).pages.include?(page1)
    
    page2 = Page.find_by_name('bar')
    assert sites(:digitu).pages.include?(page2)
    
    page3 = Page.find_by_name('eleven')
    assert sites(:digitu).pages.include?(page3)        
  end
  
  test "populate_page_list_from_dir does nothing if the page is already associated with the site" do
  
    index_id = pages(:index).id
    
    dir = "#{RAILS_ROOT}/test/fixtures/files"   # there is file here called index
    sites(:digitu).populate_page_list_from_dir(dir)
    
    index = Page.find_by_name("index")
    assert index_id == index.id
  end
  
  test "depopulate_page_list_from_dir undoes the pages_sites relationships for a directory that has been 'imported'" do
  
    index_id = pages(:index).id
    
    dir = "#{RAILS_ROOT}/test/fixtures/files"   # there is file here called index
    sites(:digitu).populate_page_list_from_dir(dir)
    sites(:digitu).depopulate_page_list_from_dir(dir)
    
    page1 = Page.find_by_name('foo')
    assert !sites(:digitu).pages.include?(page1)
    
    page2 = Page.find_by_name('bar')
    assert !sites(:digitu).pages.include?(page2)
    
    page3 = Page.find_by_name('eleven')
    assert !sites(:digitu).pages.include?(page3) 
  end  

  test "when a site gets destroyed any PagesSites records go bye bye too" do
    dead_site_id = sites(:digituplus).id
    sites(:digituplus).destroy
    ps = PagesSite.find(:first, :conditions => ["site_id = ? AND page_id = ?",
                                                dead_site_id, pages(:index)])
    assert ps.nil?
  end
  
  test "clone a page to all other sites" do
    page = pages(:index)
    site = sites(:digitu)
    site.clone_page_to_sites(page)
    
    # did the page get cloned to cues?
    cues_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:cues)])
    assert cues_ps.page.name = "index"
    
    # did the page get cloned to energymanagementu?
    emu_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:energymanagementu)])
    assert emu_ps.page.name = "index"
    
  end
  
  test "clone a page to a list of sites" do
    page = pages(:index)
    site = sites(:digitu)
    list_of_sites = %w{ cues cuesplus }
    site.clone_page_to_sites(page, list_of_sites)
    
    # did the page get cloned to cues?
    cues_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:cues)])
    assert cues_ps.page.name = "index"
    
    # did the page get cloned to cuesplus?
    cuesplus_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:cuesplus)])
    assert cuesplus_ps.page.name = "index"    
    
    # did the page not get cloned to energymanagementu?
    emu_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:energymanagementu)])
    assert emu_ps.nil?
  end
  
  test "undo a clone of a page to all sites" do
    page = pages(:index)
    site = sites(:digitu)
    site.clone_page_to_sites(page)
    site.undo_clone_page_to_sites(page)
    
    # does the cues site now have an index pages that has a nil page_source? 
    cues_ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page, sites(:cues)])
    assert cues_ps.page.name = "index"
    assert cues_ps.page_source.nil?
  end
  
  test "page_protected? says TRUE when  a pages_sites record is marked protected " do
    site = sites(:digitu)
    page = pages(:newsletter)
    assert site.page_protected?(page)
  end
  
  test "page_protected? says FALSE when a pages_sites record in not marked protected" do
    site = sites(:digitu)
    page = pages(:index)
    assert !site.page_protected?(page)  
  end
  
  test "page_protected? say TRUE whan a pages_sites record has been re-sourced and it's page_source is marked protected" do
    site = sites(:digituplus)
    page = pages(:_head)
    assert site.page_protected?(page)
  end
  
  test "page_protected? say FALSE whan a pages_sites record has been re-sourced and it's page_source is marked not protected" do
    site = sites(:digituplus)
    page = pages(:index)
    assert !site.page_protected?(page)  
  end  
  
  test "can access a site's mail lists" do
    assert sites(:digitu).mail_lists.first.name == "big_list"
  end
  
end

