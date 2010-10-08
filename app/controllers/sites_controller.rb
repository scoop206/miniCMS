class SitesController < ApplicationController
  
  layout "admin"
  before_filter :require_user, :fetch_quick_look_stuff
  
  # GET /sites
  # GET /sites.xml
  def index
    @sites = Site.all

    respond_to do |format|
      format.html { render :template => "admin_sites/index" }
      format.xml  { render :xml => @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.xml
  def show
    @site = Site.find(params[:id])

    respond_to do |format|
      format.html { render :template => "admin_sites/show" }
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.xml
  def new
    @site = Site.new

    respond_to do |format|
      format.html { render :template => "admin_sites/new" }
      format.xml  { render :xml => @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
    render :template => "admin_sites/edit"
  end
  
  def edit_pages
    @site = Site.find(params[:id])
    @pages = Page.find(:all)
    @sites = Site.find(:all)
    
    #arrays to populate js arrays which in turn populate the pagesource dialog's dropdowns
    @dialog_sites = Site.find(:all)
    
    @dialog_pages = []
    Site.find(:all).each do |site|
      pages = []
      site.ordered_pages_sites.each { |ps| pages << {:id => ps.page.id, :name => ps.page.name} if ps.self_referential? }
      @dialog_pages << {:site => site.id, :pages => pages}
    end
    render :template => "admin_sites/edit_pages"
  end

  # POST /sites
  # POST /sites.xml
  def create
    @site = Site.new(params[:site])

    respond_to do |format|
      if @site.save
        flash[:notice] = 'Site was successfully created.'
        Changelog.add(@current_user.login, "Created the site #{@site.name}")
        format.html { redirect_to(@site) }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html  { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.xml
  def update
    
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Site was successfully updated.'
        Changelog.add(@current_user.login, "Updated the #{@site.name} site")
        format.html { redirect_to(@site) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to(sites_url) }
      format.xml  { head :ok }
    end
  end
  
  def associate_page
    
    @site = Site.find(params[:id])
    @page = Page.find(params[:page][:id])
    
    #check to make sure page is not already associated
    
    _ps = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", @page, @site])
    if _ps.nil?
      ps =  PagesSite.create(:site => @site, :page => @page)
      Changelog.add(@current_user.login, "Associated the #{@page.name} page with the #{@site.name} site")
    else
      flash[:warning] = "The page '#{@page.name}' has already been associated with this site"
    end
    redirect_to edit_pages_site_url(@site)
  end
  
  def remove_page
    @site = Site.find(params[:id])
    @pages_site = PagesSite.find(params[:pages_site_id])
    @pages_site.destroy
    Changelog.add(@current_user.login, "Removed the #{@pages_site.page.name} page from the #{@site.name} site")
    redirect_to edit_pages_site_url(@site)
  end
  
  def modify_pages_site
    
    # find the pages_sites record that is associate with our page/site
    # create find the PageSource that represents new destination
    # add or remoave a pagesource to the pages_sites record
    # twiddle the protected flag
    
    # PROTECTED FLAG
    
    protected = false
    unless params[:ps_page_protected].blank?
      protected = params[:ps_page_protected] == "1"
    end
    
    # PAGE SOURCE
    
    @site = Site.find(params[:id])
    pagesource_page = Page.find(params[:ps_page]) unless params[:ps_page].blank?
    pagesource_site = Site.find(params[:ps_site][:id]) unless params[:ps_site][:id].blank?
    
    page_page = Page.find(params[:ps_form_page_id])
    page_site = @site
    
    # if either pagesource_page or pagesource_site is blank, then remove the pagesource from the page_sites
    if pagesource_page.blank? or pagesource_site.blank?
      pagesource = nil
    else
      pagesource = PageSource.find(:first, :conditions => ["page_id = ? AND site_id = ?", pagesource_page, pagesource_site])
    end  
      
    page = PagesSite.find(:first, :conditions => ["page_id = ? AND site_id = ?", page_page, page_site]) 
    
    # update page with new pagesource and protected
    page.protected = protected
    page.page_source = pagesource
    page.save!
  
    flash[:notice] = "The source for the #{@site.name} #{page.page.name} page has been changed"
    unless pagesource.nil?
      Changelog.add(@current_user.login, "Modified a pagesource. #{page.site.name}.#{page.page.name} will now show content from #{pagesource.site.name}.#{pagesource.page.name}. Protected was set to #{protected.to_s}.")
    else
      Changelog.add(@current_user.login, "Modified a pagesource. #{page.site.name}.#{page.page.name} has been set to no pagesource. . Protected was set to #{protected.to_s}.")
    end
    redirect_to edit_pages_site_url(@site)
    
  end
  
  def quick_lookup_file_location
    site = Site.find(params[:site_id])
    page = Page.find(params[:page_id])
    file_location = Site.get_page_file_location(site, page)
    render :inline => "{\"location\": \"#{file_location}\"}"
  end
  
  def status
    site = Site.find(params[:id])
    render :inline => "{\"status\": #{site.running? ? 1 : 0} }"
  end
  
  def control_server
    site = Site.find(params[:id])
    act = params[:act]
    case act
    when 'start'
      site.start
    when 'stop'
      site.stop
    when 'restart'
      site.restart
    end
    render :inline => "{ \"status\": 1}"
  end
  
end
