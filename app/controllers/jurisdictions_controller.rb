class JurisdictionsController < ApplicationController

  def index
    @jurisdictions = Jurisdiction.find(:all, :order => :name)
    @jurisdiction = Jurisdiction.new
  end

  def create
    @jurisdictions = Jurisdiction.find(:all, :order => :name)
    @jurisdiction = Jurisdiction.new(params[:jurisdiction])
    if @jurisdiction.save
      redirect_to jurisdictions_path
    else
      render 'index'
    end
  end

  # need to refactor the validation checking. build into model?
  def destroy
    @del_jurisdiction = Jurisdiction.find(params[:id])
    begin
      @del_jurisdiction.destroy
      flash[:success] = "Legal jurisdiction removed."
      redirect_to jurisdictions_path
    rescue ActiveRecord::DeleteRestrictionError
      @del_jurisdiction.errors.add(:base, 
                                   "Cannot delete when there are linked courts")
      @jurisdictions = Jurisdiction.all
      @jurisdiction = Jurisdiction.new
      render 'index', :del_jurisdiction => @del_jurisdiction
    end
  end

  def get_jurisdictions
    @jurisdictions = Jurisdiction.find(:all, :order => :name)
    respond_to do |format|
      format.json {render :json => @jurisdictions }
    end
  end


end




