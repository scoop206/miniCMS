class CreateExampleSiteVar < ActiveRecord::Migration
  
  def self.siteA
    "siteA"
  end
  
  def self.siteB
    "siteB"
  end
  
  def self.up
    site_var = SiteVar.create( :name => "example_site_var")
    
    # associate site_var with sites
    _siteA = Site.find_by_name(siteA)
    _siteA.site_vars << site_var
    _siteB = Site.find_by_name(siteB)
    _siteB.site_vars << site_var
    
    # now create unique value for each via the site_site_vars joining table/model
    _siteA.set_site_var(site_var, "AAAAAA")
    _siteB.set_site_var(site_var, "BBBBBB")
  end

  def self.down
    SiteSiteVar.all.each { |ssv| ssv.destroy }
    SiteVar.first.destroy
  end
end
