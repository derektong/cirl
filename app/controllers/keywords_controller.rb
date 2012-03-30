class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.find(:all, :order => :description )
    @keyword = Keyword.new
  end

  def create
    @keywords = Keyword.find(:all, :order => :description )
    @keyword = Keyword.new(params[:keyword])
    if @keyword.save
      redirect_to keywords_path
    else
      render 'index'
    end
  end

  def destroy
    Keyword.find(params[:id]).destroy
    flash[:success] = "Legal keyword removed."
    redirect_to keywords_path
    respond_to do |format|
      format.html { redirect_to keywords_path }
      format.js { render :js => "window.location = '" + keywords_path + "'" }
    end
  end

  def update
    @keywords = Keyword.find(:all, :order => :description )
    @edited_keyword = Keyword.find(params[:id])
    @keyword = Keyword.new
    if @edited_keyword.update_attributes(:description => params[:update_value])
      redirect_to keywords_path
    else
      render 'index'
    end
  end

end
