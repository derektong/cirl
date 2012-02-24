class CourtsController < ApplicationController

  before_filter :init, :only => [:index, :create, :update]

  def index
    @court = Court.new
  end

  def create
    @court = Court.new(params[:court])
    if @court.save
      redirect_to courts_path
    else
      render 'index'
    end
  end

  def destroy
    Court.find(params[:id]).destroy
    flash[:success] = "Legal court removed."
    redirect_to courts_path
  end

  def for_jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id( params[:id] ) 
    respond_to do |format|
      format.json {render :json => @courts }
    end
  end


  def update
    @edited_court = Court.find(params[:id])
    @court = Court.new
    if @edited_court.update_attributes(:name => params[:update_value], 
                                       :jurisdiction_id => params[:jurisdiction_id] )
      #redirect_to courts_path
      render 'index'
    else
      render 'index'
    end
  end

  protected

  def init
    @courts = Court.find(:all, :order => :name, :include => :jurisdiction )
    @jurisdictions = Jurisdiction.find(:all, :order => :name, :include => :courts )
  end

end



