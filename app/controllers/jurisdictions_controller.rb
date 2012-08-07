class JurisdictionsController < ApplicationController
  before_filter :init, :only => [:index, :create, :destroy]
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @jurisdiction = Jurisdiction.new
  end

  def create
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
      @del_jurisdiction.destroy
      flash[:success] = "Jurisdiction: \""+@del_jurisdiction.name + "\" removed"
      redirect_to jurisdictions_path
    rescue ActiveRecord::DeleteRestrictionError
      @del_jurisdiction.errors.add(:base, 
                                   "Cannot delete when there are linked courts")
      @jurisdiction = Jurisdiction.new
      render 'index', :del_jurisdiction => @del_jurisdiction
    end
  end

  protected

  def init
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)" )
  end

end


