class JurisdictionsController < ApplicationController
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)")
    @jurisdiction = Jurisdiction.new
  end

  def create
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)")
    @jurisdiction = Jurisdiction.new(params[:jurisdiction])
    if @jurisdiction.save
      flash[:success] = "Jurisdiction: \"" + @jurisdiction.name + "\" added"
      redirect_to jurisdictions_path
    else
      render 'index'
    end
  end

  # need to refactor the validation checking. build into model?
  def destroy
    @del_jurisdiction = Jurisdiction.find(params[:id])
    begin
      flash[:success] = "Jurisdiction: \""+@del_jurisdiction.name + "\" removed"
      @del_jurisdiction.destroy
      redirect_to jurisdictions_path
    rescue ActiveRecord::DeleteRestrictionError
      @del_jurisdiction.errors.add(:base, 
                                   "Cannot delete when there are linked courts")
      @jurisdictions = Jurisdiction.all
      @jurisdiction = Jurisdiction.new
      render 'index', :del_jurisdiction => @del_jurisdiction
    end
  end
end




