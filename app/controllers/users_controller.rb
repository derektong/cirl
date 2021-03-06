class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :managing_admin_user, only: [:toggle_admin]
  before_filter :signed_in_or_managing_admin_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def cases
    @user = User.find(params[:id])
  end

  def legal_briefs
    @user = User.find(params[:id])
  end

  def uploaded_legal_briefs
    @user = User.find(params[:id])
    @legal_briefs = LegalBrief.find_all_by_user_id( @user.id )
  end

  def legal_resources
    @user = User.find(params[:id])
  end

  def case_searches
    @user = User.find(params[:id])
    @recent_case_searches = @user.case_searches.find_all_by_name( nil, :order => "created_at DESC" )
    @saved_searches = @user.case_searches.find(:all, :conditions => "name IS NOT NULL" )
  end

  def legal_resource_searches
    @user = User.find(params[:id])
    @recent_legal_resource_searches = @user.legal_resource_searches.find_all_by_name( nil, :order => "created_at DESC" )
    @saved_searches = @user.legal_resource_searches.find(:all, :conditions => "name IS NOT NULL" )
  end


  def edit
  end

  def new
    @user = User.new
  end

  def index
    @users = User.find(:all, :order => "user_type DESC, LOWER(name)" )
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Test"
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User removed."
    redirect_to users_path
  end

  def toggle_admin
    @user = User.find(params[:id])
    if @user.toggle_admin
      flash[:success] = "User type changed: " + @user.name
      redirect_to users_path
    else
      flash[:error] = "Error changing user type: " + @user.name
      redirect_to users_path
    end
  end

  private 

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) 
  end

  def signed_in_or_managing_admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless (current_user.managing_admin? || 
                                   current_user?(@user) )
  end

end
