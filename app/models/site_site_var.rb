class SiteSiteVar < ActiveRecord::Base
  belongs_to :site
  belongs_to :site_var
  
  validates_presence_of :site_id, :site_var_id
  
  def site_name
    return "default" if site_id == 0
    site.name
  end
  
end
