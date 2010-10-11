class ChangelogController < ApplicationController
  
  layout 'admin'
  before_filter :require_user
  
  def index
    @changelogs = Changelog.find(:all)
  end

end
