class CloneSiteAIndexPageToSiteB < ActiveRecord::Migration
  
  def self.source_site
    Site.find_by_name("siteA")
  end
  
  def self.target_site
    Site.find_by_name("siteB")
  end
  
  def self.page
    Page.find_by_name("index")
  end
  
  def self.up
    source_site.clone_page_to_sites(page)
  end

  def self.down
    source_site.undo_clone_page_to_sites(page)
  end
end
