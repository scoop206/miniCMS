class HomeController < ApplicationController

  before_filter :get_current_user, :special_cases, :assets, :route_to_view
  layout :get_layout

  ################################################################################################
  #
  # route_to_view
  #
  # summary:  the primary page delivery method, which is accomplished by @site.get_view(params[:action])
  # result: if a page is found to match the @site we're in, render it
  # =>      else return a 404
  #
  ################################################################################################

  def route_to_view
  
    @page = Page.find_by_name(params[:action])
  
    respond_to do |format|
      format.html do
      
        if @site.page_protected?(@page)
            render :template => "sites/#{Site.first.name}/protected" and return
        end
      
         path = @site.get_view(params[:action])
         unless !path
           render :template => path
         else
           render_404
         end
      end
    end
  end

  def render_404(exception = nil)
  
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    respond_to do |format|
      format.html { render :template => @site.shared_404, :status => :not_found } 
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
    true
  end

  def get_current_user
    current_user("normal")
  end

  ################################################################################################
  #
  # special_cases
  #
  # summary:  handle any special contoller processing you might need to do on a particular page
  # =>        for example: 
  # 
  #           %w{ free_trial_request enews_signup_request customer_feedback_request }.each do |request|
  #             if params[:action] == request
  #               customer_request(request) and return
  #             end
  #           end
  #
  ################################################################################################

  def special_cases
    if params[:action] == "sitemap"
      sitemap and return
    end
  
    if params[:action] == 'robots'
      robots and return
    end
  end


  ################################################################################################
  #
  # assets
  #
  # summary:  catch urls that are looking file assets
  #           if either params[:path] is filled or params[:format] is filled then we are dealing with one of these types
  #
  # result: call get_from_asset_folder to start the downoad
  #
  ################################################################################################

  def assets
  
    if !params[:path].blank? or !params[:format].blank?
      if get_from_asset_folder
        return
      else
        render_404 and return
      end
    end
  end

  def sitemap
    xml = Builder::XmlMarkup.new(:indent => 2)
    @site.build_sitemap(xml)
    render :inline => xml.target!
  end

  def robots
    render :template => "sites/#{Site.first.name}/robots" 
  end

  def get_from_asset_folder
  
    uri = CGI::unescape(request.request_uri)
    site_asset_exists = @site.asset_path(uri)
    if site_asset_exists
      redirect_to('/' + File.join(Site::ASSET_ROOT_SYMBOLIC_LINK, @site.asset_folder, uri))
    else
      general_asset_exists = @site.general_asset_path(uri)
      if general_asset_exists
  	    redirect_to('/' + File.join(Site::ASSET_ROOT_SYMBOLIC_LINK, uri))	  
      else
        return false
      end
    end 
    true

  end

  def file_type(format)
    type = ""
    # case format
    #  when 'htm', 'html'
    #    type = "text/html"
    #  when 'pdf'
    #    type = "application/pdf"
    #  when 'swf'
    #    type = "application/x-shockwave-flash"
    #  end
  
    mime_type = Mime::Type.lookup_by_extension(format)
    type = mime_type.to_s unless mime_type.nil?
    type
  end

  private

  def get_layout
    @site.layout
  end

end
