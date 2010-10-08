class ChangelogController < ApplicationController
  
  layout 'admin'
  before_filter :require_user, :fetch_quick_look_stuff
  
  def index
    @changelogs = Changelog.find(:all)
  end

end
