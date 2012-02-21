class JurisdictionsController < ApplicationController

  def index
    @jurisdictions = Jurisdiction.all
    @jurisdiction = Jurisdiction.new
  end

  def create
    @jurisdictions = Jurisdiction.all.sort_by {|a| a[:name].downcase}
    @jurisdiction = Jurisdiction.new(params[:jurisdiction])
    if @jurisdiction.save
      redirect_to jurisdictions_path
    else
      render 'index'
    end
  end

  def destroy
    Jurisdiction.find(params[:id]).destroy
    flash[:success] = "Legal jurisdiction removed."
    redirect_to jurisdictions_path
  end

  def get_jurisdictions
    @jurisdictions = Jurisdiction.find(:all, :order => :name)
    respond_to do |format|
      format.json {render :json => @jurisdictions }
    end
  end


end




