class AddAllTemplatesInSiteAAsPagesAssociatedWithSiteA < ActiveRecord::Migration
  
  def self.siteA
    "siteA"
  end
  
  def self.up
    site = Site.find_by_name(siteA)
    site.populate_page_list_from_dir
  end

  def self.down
    site = Site.find_by_name(siteA)
    site.depopulate_page_list_from_dir
  end
end
