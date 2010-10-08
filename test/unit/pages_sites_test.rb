require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
# require 'test_helper'

class PagesSitesTest < ActiveSupport::TestCase
  
  test "accessing fixture data" do
    assert pages_sites(:foo_site1_index).site.name = "foo_site1"
    assert pages_sites(:foo_site1_index).page.name = "index"
  end
  
  test "verify that I can't create 2 pages_sites records that have identical page_id and site_id" do
    
    # a pages_sites record for foo_site1_welcome already exists
    ps = PagesSite.create(:page => pages(:welcome), :site => sites(:foo_site1))
    assert ps.id.nil?
  end
  
end
