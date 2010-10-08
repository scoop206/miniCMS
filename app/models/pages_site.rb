class PagesSite < ActiveRecord::Base
  belongs_to :page
  belongs_to :site
  belongs_to :page_source

  validates_presence_of :site_id, :page_id
  validates_uniqueness_of :site_id, :scope => :page_id
  
  def self_referential?
    # true if the pages_site has a nil page_source or has a page_source that is refering to itself
    _r = false
    if page_source.nil?
          _r = true 
    elsif page_source.page == page and page_source.site == site
          _r = true 
    end
    _r
  end  
  

end
