require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
# require 'test_helper'

class PagesSitesTest < ActiveSupport::TestCase
  
  test "accessing fixture data" do
    assert pages_sites(:digitu_index).site.name = "digitu"
    assert pages_sites(:digitu_index).page.name = "index"
  end
  
  test "verify that I can't create 2 pages_sites records that have identical page_id and site_id" do
    
    # a pages_sites record for digitu_welcome already exists
    ps = PagesSite.create(:page => pages(:welcome), :site => sites(:digitu))
    assert ps.id.nil?
  end
  
end
