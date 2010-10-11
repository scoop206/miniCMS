class SiteVarsController < ApplicationController
  
  layout "admin"
  before_filter :require_user  
  
  # GET /site_vars
  # GET /site_vars.xml
  def index
    @sites = site_list_plus_default
    @site_vars = site_vars
    @_sites = Site.all
    @_site_vars = SiteVar.all
    
    unless params[:_site].blank?
      unless params[:_site] == "0"
        @site = Site.find(params[:_site])
      else # a little hackery to get around the fact that our default site can't be looked up
        @site = Site.new
        @site.id = 0
      end
    end
    unless params[:site_var].blank?
      @site_var = SiteVar.find(params[:site_var])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_vars }
    end
  end

  # GET /site_vars/1
  # GET /site_vars/1.xml
  def show
    @site_var = SiteVar.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_var }
    end
  end

  # GET /site_vars/new
  # GET /site_vars/new.xml
  def new
    @site_var = SiteVar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_var }
    end
  end

  # GET /site_vars/1/edit
  def edit
    @site_var = SiteVar.find(params[:id])
  end

  # POST /site_vars
  # POST /site_vars.xml
  def create
    @site_var = SiteVar.new(params[:site_var])

    respond_to do |format|
      if @site_var.save
        flash[:notice] = 'SiteVar was successfully created.'
        Changelog.add(@current_user.login, "A new site_var was created: #{@site_var.inspect}") 
        format.html { redirect_to(@site_var) }
        format.xml  { render :xml => @site_var, :status => :created, :location => @site_var }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_var.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_vars/1
  # PUT /site_vars/1.xml
  def update
    @site_var = SiteVar.find(params[:id])

    respond_to do |format|
      if @site_var.update_attributes(params[:site_var])
        flash[:notice] = 'SiteVar was successfully updated.'
        Changelog.add(@current_user.login, "A site_var was updated to: #{@site_var.inspect}") 
        format.html { redirect_to(@site_var) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_var.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_vars/1
  # DELETE /site_vars/1.xml
  def destroy
    @site_var = SiteVar.find(params[:id])
    @site_var.destroy
    Changelog.add(@current_user.login, "A site_var was destroyed: #{@site_var.inspect}") 

    respond_to do |format|
      format.html { redirect_to(site_vars_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_site_var
    site_var = SiteVar.find(params[:site_var])
    if params[:_site] == "0" # default site
      site_var.set_default(params[:value])
      Changelog.add(@current_user.login, "The site_var #{site_var.name}'s value for the default site was set to: #{params[:value]}") 
    else 
      site = Site.find(params[:_site])
      site.set_site_var(site_var, params[:value])
      Changelog.add(@current_user.login, "The site_var #{site_var.name}'s value for #{site.name} was set to: #{params[:value]}") 
    end
    
    redirect_to site_vars_path(:_site => params[:_site], :site_var => params[:site_var])
                                      
  end
  
  # def get_site_var_value
  #    site_site_var = SiteSiteVar.find(:first, :conditions => ["site_id = ? AND site_var_id = ?", params[:_site], params[:site_var]])
  #    value = site_site_var.nil? ? "" : site_site_var.value
  #    render :inline => "{\"value\": \"#{value}\"}"
  #  end
  
  private
  
  def site_list_plus_default
  # returns a hash of all sites with the addition of a default
    sites = {}
    Site.all.each { |site| sites[site.name] = site.id }
    sites[:default] = 0
    sites
  end
  
  def site_vars
    site_vars = {}
    SiteVar.all.each { |site_var| site_vars[site_var.name] = site_var.id }
    site_vars
  end
  
end
