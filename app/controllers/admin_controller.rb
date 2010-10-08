class AdminController < ApplicationController

layout "admin"
before_filter :require_user, :fetch_quick_look_stuff

end
