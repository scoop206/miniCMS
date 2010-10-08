class Page < ActiveRecord::Base
  
  has_many :pages_sites, :dependent => :destroy
  has_many :sites, :through => :pages_sites
  default_scope :order => "name"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  
  # sitemap
  
  def change_frequency
    "yearly"
  end
  
  def priority
    ".5"
  end

end
