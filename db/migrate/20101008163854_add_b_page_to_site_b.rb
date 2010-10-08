class AddBPageToSiteB < ActiveRecord::Migration
  
  def self.site
    Site.find_by_name("siteB")
  end
  
  def self.page_name
    "b_page"
  end
  
  def self.up
    site.add_page(page_name)
  end

  def self.down
  end
end
