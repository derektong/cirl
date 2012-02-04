class CourtController < ApplicationController
  def list
    @courts = Court.find(:all)
  end
  def show
    @court = Court.find(params[:id])
  end
  def new
    @court = Court.new
    @jurisdictions = Jurisdiction.find(:all)
  end
  def create
    @court = Court.new(params[:court])
    if @court.save
      redirect_to :action => 'list'
    else
      @jurisdictions = Jurisdiction.find(:all)
      render :action => 'new'
    end
  end
  def edit
    @court = Court.find(params[:id])
    @jurisdictions = Jurisdiction.find(:all)
  end
  def update
    @court = Court.find(params[:id])
    if @court.update_attributes(params[:court])
      redirect_to :action => 'show', :id => @court
    else
      @jurisdictions = Jurisdiction.find(:all)
      render :action => 'edit'
    end
  end
  def delete
    Court.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  def show_jurisdictions
    @jurisdictions = Jurisdiction(param[:id])
  end
end
