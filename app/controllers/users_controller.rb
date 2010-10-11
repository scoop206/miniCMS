class UsersController < ApplicationController

  before_filter :require_user

  layout "admin"

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @user_roles = UserRole.find(:all)
    @user_role = UserRole.find_by_name("basic")
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user_roles = UserRole.find(:all)
    @user_role = @user.user_role
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.user_role = UserRole.find(params[:user_role][:id])
    
    if @user.save
      flash[:notice] = "Account registered!"
      Changelog.add(@current_user.login, "Created the #{@user.login} user")
      redirect_to @user
    else
      render :action => :new
    end
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    
    @user = User.find(params[:id])
    @user.user_role = UserRole.find(params[:user_role][:id])
    @user_roles = UserRole.find(:all)
    @user_role = @user.user_role
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        Changelog.add(@current_user.login, "Updated the #{@user.login} user.  Login: #{@user.login}; Name: #{@user.name}; Email: #{@user.email}; Role: @user.user_role.name")
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    Changelog.add(@current_user.login, "Removed the #{@user.login} user")

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
