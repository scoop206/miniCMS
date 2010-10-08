class SiteVar < ActiveRecord::Base

  has_many :site_site_vars, :dependent => :destroy
  has_many :sites, :through => :site_site_vars, :dependent => :destroy
  validates_presence_of :name
  validates_uniqueness_of :name
  
  DEFAULT_SITE = 0

  def get_value_for_site(site)
    # does the site have a value for this site_var?
    site_site_var = SiteSiteVar.find(:first, :conditions => ["site_id = ? AND site_var_id = ?", site, self])
    site_site_var.nil? ? nil : site_site_var.value
  end
  
  def default_value
    site_site_var = SiteSiteVar.find(:first, :conditions => ["site_id = ? AND site_var_id = ?", DEFAULT_SITE, self])
    site_site_var.value unless site_site_var.nil?
  end

end
