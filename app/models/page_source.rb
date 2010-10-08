class PageSource < ActiveRecord::Base 
  
  has_many :pages_sites
  belongs_to :page
  belongs_to :site
  belongs_to :page_source
  
  set_table_name "pages_sites"
  
  validates_presence_of :page_id, :site_id
  
  def to_s
    "#{site.name}.#{page.name}"
  end
end
