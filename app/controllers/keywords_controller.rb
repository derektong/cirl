class KeywordsController < ApplicationController
  before_filter :init, :only => [:index, :create, :edit, :update]
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @keyword = Keyword.all.first
    @alias = Alias.new
  end

  def edit
    @keyword = Keyword.find(params[:id])
  end

  def create
    @keyword = Keyword.new(params[:keyword])
    if @keyword.save
      redirect_to keywords_path
    else
      render 'index'
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])
    flash[:success] = "Keyword: \"" + @keyword.description + "\" deleted"
    @keyword.destroy
    redirect_to keywords_path
  end

  def update
    @edited_keyword = Keyword.find(params[:id])
    @keyword = Keyword.new
    if @edited_keyword.update_attributes(params[:keyword])
      flash[:success] = "Keyword: \"" + @edited_keyword.description + "\" updated"
      redirect_to keywords_path
    else
      render 'index'
    end
  end

  protected

  def init
    @keywords = Keyword.find(:all, :order => "LOWER(description)", include: :aliases )
  end

end
