class DuEnvHelper
  
  def self.site_env?
    # are we running as one of the sites? (siteA, siteB, etc.)
    RAILS_ENV.include?('_') 
  end
  
  def self.site
    RAILS_ENV.split('_').first
  end

  def self.site_env
    RAILS_ENV.split('_').last
  end
  
end