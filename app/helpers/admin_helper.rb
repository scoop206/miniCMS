module AdminHelper
  
  ################################################################################################
  #
  # fetch_quick_look_stuff
  #
  # summary: the admin pages have a quick look widget that informs about
  # =>       which template file is associated with which site/page 
  # =>       this function populates @ql_pages with all site/page info
  #
  ################################################################################################

  def fetch_quick_look_stuff
    unless @ql_sites and @ql_pages
      @ql_sites = Site.find(:all)
    
      @ql_pages = []
      Site.find(:all).each do |site|
        pages = []
        site.ordered_pages.each { |p| pages << {:id => p.id, :name => p.name} }
        @ql_pages << {:site => site.id, :pages => pages}
      end
    end
  end
  
end
