# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :add_site
  
  ################################################################################################
  #
  # add_site
  #
  # summary: set the @site
  # =>       this can be two ways
  # =>      1)  environment on spin up (e.g. script/server -e siteA_development
  # =>      2)  query string (e.g. http://siteA.com/foo_action?site=siteB
  # =>      Will default to first site in sites tables if not specified
  #
  ################################################################################################
  
  
  def add_site
    
    unless DuEnvHelper::site_env? # are we running using a custom env to tell us which site we should be?
      # lookup the site name passed on url and push it's id into the params[:site] instead
      unless params[:site].nil?
         if params[:site] =~ /[a-zA-Z]/   #site has letters in it
         
           site = Site.find_by_name(params[:site])
           if site.nil?
             params[:site] = nil
           else
             params[:site] = site.id unless site.nil?
           end
         end
      end
      unless params[:controller] == 'sites'
        params[:site] ||= Site.first.id
        @site = Site.find(params[:site])
      end
    else # we are is a custom env (siteA_production, siteB_production, etc)
      @site = Site.find_by_name(DuEnvHelper::site)
    end
  end
  
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
    @ql_sites = Site.find(:all)
    
    @ql_pages = []
    Site.find(:all).each do |site|
      pages = []
      site.ordered_pages.each { |p| pages << {:id => p.id, :name => p.name} }
      @ql_pages << {:site => site.id, :pages => pages}
    end
  end

  private
  
  ################################################################################################
  #
  # authlogic functions
  #
  ################################################################################################
  
    # admin user persistence methods
    def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
    end
    
    def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        # flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      # these pages cause problems when directing back to so we'll special case them
      unless session[:return_to].nil?
        %w{ user/show account }.each do |page|
          redirect_to(default) and return if session[:return_to].include?(page)
        end
      end
      #otherwise return to the page you're trying to get to
      redirect_to(session[:return_to] || default) and return
      session[:return_to] = nil
    end
end
