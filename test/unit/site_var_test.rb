require File.join(File.dirname(File.dirname(__FILE__)), 'test_helper')
#require 'test_helper'

class SiteVarTest < ActiveSupport::TestCase
  
  test "setting a site_var value" do
    site_var = site_vars(:fruit)
    site = sites(:foo_site1)
    site.set_site_var(site_var, "bannana")
    assert site.site_var("fruit") == "bannana"
  end
  
  test "setting default value"  do
    site_var = site_vars(:fruit)
    site_var.set_default("peach")
    assert site_var.default_value == "peach"
  end
  
end
