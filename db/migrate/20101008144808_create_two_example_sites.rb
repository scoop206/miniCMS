class CreateTwoExampleSites < ActiveRecord::Migration
  
  # siteA and siteB
  # siteB will be a clone of A
  
  def self.siteA
    "siteA"
  end
  
  def self.siteB
    "siteB"
  end
  
  def self.up
    
      Site.create(  :name => siteA,
                    :official_name => siteA,
                    :url => "http://" + siteA + ".com",
                    :layout => siteA,
                    :asset_folder => siteA)
                    
      Site.create(  :name => siteB,
                    :official_name => siteB,
                    :url => "http://" + siteB + ".com",
                    :layout => siteA,                   #  <<<< note siteA's layout
                    :asset_folder => siteB)  
  end
                    
def self.down
    [ siteA, siteB ].each do |site_name|
      Site.find_by_name(site_name).destroy
    end
  end
end
