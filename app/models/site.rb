class Site < ActiveRecord::Base
  
  has_many :pages_sites, :dependent => :destroy
  has_many  :pages, 
            :through => :pages_sites
  has_many  :site_site_vars,
            :dependent => :destroy
  has_many  :site_vars,
            :through => :site_site_vars,
            :dependent => :destroy                          
            
  default_scope :order => "name"
  validates_presence_of :name
  validates_uniqueness_of :name
  
  ASSET_ROOT = '/var/rails/duwc/shared/assets'
  ASSET_ROOT_SYMBOLIC_LINK = 'assets' # name of the sl that exists in RAILS_ROOT/public pointing to ASSET_ROOT
  
  ############################################################################################################
  #
  # get_view(action)
  #
  # summary: return the string indicating which view to render
  #           e.g. 'siteA/index' if siteA is the page_source for this site for the index action
  # accepts: the action (string) the site is responding to
  # returns: the path (string)
  #
  ############################################################################################################  
  
  
  def get_view(action)
  
    the_page = Page.find(:first, :conditions => ["name = ?", action])
  
    # get our view for this action
    ps = pages_sites.find(:first, :conditions => ["page_id = ?", the_page])
    
    #if could not find page associated with this site then return false
    if ps.nil?
      return false
    end
    
    unless ps.page_source.nil?
      "sites/#{ps.page_source.site.name}/#{Site.strip_underscore_from_front(ps.page_source.page.name)}"
    else
      "sites/#{name}/#{Site.strip_underscore_from_front(action)}" 
    end
  end
  
  def shared_404
  # this is hardcoded to the first site's template
    "sites/#{Site.first.name}/404"
  end
  
  ############################################################################################################
  #
  # self.strip_underscore_from_front(string)
  #
  # summary: remove the underscore at the front of the string
  #          this is neccessary b/c we are passing pages and partials into get_view but when calling
  # =>        render :partial => "blah" we dont' want the underscore to be infront of blah
  # accepts: the string (string)
  # returns: string (string) without underscore in front
  #
  ############################################################################################################
  
  def self.strip_underscore_from_front(string)
    string.gsub!(/^_/,'')
    string
  end
  
  def ordered_pages
    pages.sort { |x,y| x.name <=> y.name }
  end
  
  def ordered_pages_sites
  # ordered by the page order
    pages_sites.sort { |x,y| x.page.name <=> y.page.name }
  end
  
  def page_sites_orderd_by_page
    pages_sites.sort { |x,y| x.page.name <=> y.page.name }
  end
  
  def path
    "#{RAILS_ROOT}/app/views/sites/#{self.name}"
  end
  
  def self.get_page_file_location(site, page)
    location = nil
    pages_site = site.pages_sites.find(:first, :conditions => ["page_id = ?", page])
    
    return location if pages_site.nil?
    
    if pages_site.page_source.blank?
      location = File.join(site.path, page.name + ".html.erb")
    else
      # get the page source and find the location for it's site/page
      location = File.join(pages_site.page_source.site.path, pages_site.page_source.page.name + ".html.erb")
    end
    location
  end
  
  def get_image(name)
    # if the image exists in the layou specific location then return that path
    # other return the generic page (/images/name)
        
    site_image = File.join(image_path, name)
    
    if File.exist?(File.join(RAILS_ROOT, "public", site_image))
      site_image
    else
      "/images/" + name
    end
    
  end
  
  def get_favicon(favicon)
    File.join("/favicon", layout, favicon)
  end
  
  def image_path
    "/images/" + layout
  end
  
  def page_protected?(page)
    ps =  pages_sites.find(:first, :conditions => ["page_id = ?", page])
    return false if ps.nil?
    
    # if the page has a pagesource pointing to another page then return the status of that page
    if ps.page_source.blank?
      ps.protected?
    else
      ps.page_source.protected?
    end
  end
  
  def site_var_without_default(site_var)
    # return the value with the site_var that's associated with this site
    site_var.get_value_for_site(self) 
  end
  
  def site_var(site_var_name)
    # return the value with the site_var that's associated with this site or the default value for that site_var
    site_var = SiteVar.find_by_name(site_var_name)
    value = self.site_var_without_default(site_var)
    if value.blank?
      value = site_var.default_value
    end
    value
  end
  
  def set_site_var(site_var, value)
    site_site_var = SiteSiteVar.find( :first, 
                                      :conditions => ["site_id = ? AND site_var_id = ?", self, site_var])
    site_site_var = SiteSiteVar.create(:site_id => self.id, :site_var_id => site_var.id) if site_site_var.nil?
    
    site_site_var.value = value
    site_site_var.save!
  end
  
  def restart
    command = "mongrel_rails cluster::restart -C #{RAILS_ROOT}/config/#{name}_mongrel_cluster.yml"
    system command
  end
  
  def stop
    command = "mongrel_rails cluster::stop -C #{RAILS_ROOT}/config/#{name}_mongrel_cluster.yml"
    system command
  end
  
  def start
    command = "mongrel_rails cluster::start -C #{RAILS_ROOT}/config/#{name}_mongrel_cluster.yml"
    system command
  end
  
  def running?
    
    # is the site running
    # this assumes the process was started using the SITE_NAME_production environment idiom
    
    result = %x[ps auxww | grep #{name}_production]
    result.include?('mongrel_rails')
  end
  
  def asset_path(uri)
    # summary: returns true if the uri that is pointing to an asset can be resolved
    # =>        via the site specific asset folder
    
    my_asset_path = File.join(ASSET_ROOT, asset_folder, uri)
    File.exists?(my_asset_path)
  end
  
  def general_asset_path(uri)
    # summary: returns true if the uri that is pointing to an asset can be resolved
    # =>        via the general asset folder
    
    general_asset_path = File.join(ASSET_ROOT, uri)
    File.exists?(general_asset_path)
  end
  
  # UTILS FUNCTIONS THAT HELP BUILD OUT AND MIGRATE SITES
  
  def add_page(page_name)
    
    #does page exist? if not then create it
    page = Page.find_by_name(page_name)
    page = Page.create(:name => page_name) if page.nil?
    
    # now associate page with this site
    ps = pages_sites.find(:first, :conditions => ["page_id = ?", page])
    ps = PagesSite.create(:page => page, :site => self) if ps.nil?
    page
  end
  
  def remove_page(page_name)
   
    #does page exist? if not then create it
    page = Page.find_by_name(page_name)
    page = Page.create(:name => page_name) if page.nil?
    
    # now dis-associate page with this site
    ps = pages_sites.find(:first, :conditions => ["page_id = ?", page])
    ps.destroy unless ps.nil?       
    
  end
  
  def populate_page_list_from_dir(directory = nil)
  # a utility function to be used when needing to build a list of pages from a directory
  # if no directory is passed it defaults the app/views/SITE_NAME
    directory ||= self.path
    Dir.new(directory).each do |file|
       unless file =~ /^\./
         basename = file.split(".html.erb").first
         
         # get a page object
         page = Page.create( :name => basename )
         if page.id.nil? # this would happen if this page name was already in use
           page = Page.find_by_name(basename)
         end
         
         # create a pages_site relational object
         unless self.pages.include?(page)
           PagesSite.create( :site => self, :page => page )
         end
       end
    end
  end
  
    def depopulate_page_list_from_dir(directory = nil)
  # a utility function to be used when needing to unbuild a list of pages from a directory
  # this can not work as a perfect undo so instead will just unassociate all pages that were in the dir from the site
  # the page objects themselves will continue to exist
  
    directory ||= self.path
    Dir.new(directory).each do |file|
       unless file =~ /^\./
         basename = file.split(".html.erb").first
         
         # get a page object
         page = Page.find_by_name(basename)
         
         ps = pages_sites.find(:first, :conditions => ["page_id = ?", page])
         ps.destroy unless ps.nil?         
         
       end
    end
  end
  
  def clone_to(target_site)
  # takes all the pages associated with this site and associates them with target site (all target sites pages has their page
  
    # all the pages will already exist, so we just need to create the pages_sites relational records for the ts
    self.pages_sites.each do |pages_site|
      
      # if page source is set in source record then use that in the record we're creating
      # else set new records page source to old record
      unless pages_site.page_source.nil?
        page_source = pages_site.page_source
      else
        page_source = PageSource.find(pages_site.id)
      end
      
      PagesSite.create( :page => pages_site.page, :site => target_site, :page_source => page_source )
    end
  end
  
  def undo_clone_to(target_site)
    self.pages_sites.each do |pages_site|
      _ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", pages_site.page, target_site])
      _ps.destroy unless _ps.nil?
    end
  end
  
  def clone_page_to_sites(page, site_list = nil)
  
  # clones a page to other sites
  # accepts a list of names for the sites in the parameter
  # otherwise clones to every other site
    
    ps = pages_sites.find(:first, :conditions => ["page_id = ?", page])
    return if ps.nil?
   
    sites = []
    if site_list.nil?
     sites = Site.find(:all)
    else
      site_list.each { |site_name| sites << Site.find_by_name(site_name) }
    end
    
    sites.each do |site|
      site_ps = site.pages_sites.find(:first, :conditions => ["page_id = ?", page])
      if site_ps.nil?
        site_ps = PagesSite.create(:page => page, :site => site)
      end
      site_ps.page_source = PageSource.find(:first, :conditions => ["page_id = ? and site_id = ?", page, self])
      site_ps.save!
    end
  end
  
  def undo_clone_page_to_sites(page, site_list = nil)
  
  # undos the page_source association in the target sites
  # does however leave the pages associated with the site b/c this would be hard to know if we need to undo or not
    
    ps = pages_sites.find(:first, :conditions => ["page_id = ?", page])
    return if ps.nil?
   
    sites = []
    if site_list.nil?
     sites = Site.find(:all)
    else
      site_list.each { |site_name| sites << Site.find_by_name(site_name) }
    end 
    
    sites.each do |site|
      site_ps = site.pages_sites.find(:first, :conditions => ["page_id = ?", page])
      site_ps.page_source = nil
      site_ps.save!
    end
  end
  
  # END UTILS
  
  def build_sitemap(xml)
  
  # accepts a builder object
  # populates it with url data per the sitemap protocol:
  # http://www.sitemaps.org/protocol.php
    
    xml.instruct!
    xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9") {
      sitemap_pages.each do |page|
        xml.url {
          xml.loc url + "/" + page.name
          xml.lastmod page_last_modified(page).strftime('%Y-%m-%d')
          xml.changefreq page.change_frequency
          xml.priority page.priority
        }
      end
    }
  end
  
  def page_last_modified(page)
    
    # returns a time object indicating when the page was last modified
    file = Site.get_page_file_location(self, page)
    mod_time = File.mtime(file)
  end
  
  def sitemap_pages
    # get all pages that aren't protected and that aren't a partial
    _pages = []
    pages_sites.each do |ps|
      
      # if it's a partial, move on
      next if ps.page.name =~ /^_/
      
      _protected = ps.protected?
      
      # if the page has a different page_source, is that page_source protected?
      unless _protected or ps.self_referential? 
        other_ps = PagesSite.find(ps.page_source.id)
        _protected = other_ps.protected?
      end
      
      _pages << ps.page unless _protected
    end
    _pages
  end
  
end
