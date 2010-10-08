require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')

class PageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "cannot create two pages with the same name" do
    
    # we already have a fixture with the page name 'index'
    # let's try and create another
    page = Page.create(:name => 'index')
    assert page.id.nil?
    
  end
  
  test "when a page gets destroyed any PagesSites records go bye bye too" do
    dead_page_id = pages(:index).id
    pages(:index).destroy
    ps = PagesSite.find(:first, :conditions => ["site_id = ? AND page_id = ?",
                                                sites(:foo_site1), dead_page_id])
    assert ps.nil?
  end
  
end
