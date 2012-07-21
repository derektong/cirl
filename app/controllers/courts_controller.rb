class CourtsController < ApplicationController
  include CourtsHelper

  before_filter :init, :only => [:index, :create, :update, :edit, :restore]

  def index
    @court = Court.new
  end

  def create
    @court = Court.new(params[:court])
    if @court.save
      flash[:success] = "Court: \"" + @court.name + "\" added"
      redirect_to courts_path
    else
      render 'index'
    end
  end

  def edit
    @court = Court.find(params[:id])
  end

  def destroy
    @court = Court.find(params[:id])
    flash[:success] = "Court: \"" + @court.name + "\" deleted"
    @court.destroy
    redirect_to courts_path
  end

  def for_jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id( params[:id].split(','), :include => :jurisdiction, :order => 'jurisdictions.name, courts.name' )
    respond_to do |format|
      format.json {render :json => @courts.to_json(:include => [:jurisdiction]) }
    end
  end

  def update
    @edited_court = Court.find(params[:id])
    @court = Court.new
    if @edited_court.update_attributes(params[:court])
      flash[:success] = "Court: \"" + @edited_court.name + "\" updated"
      redirect_to courts_path
    else
      render 'index'
    end
  end

  def restore
    restore_courts
    @court = Court.new
    redirect_to courts_path
  end

  protected

  def init
    @courts = Court.find(:all, :order => "LOWER(name)", :include => :jurisdiction )
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)", :include => :courts )
  end

end



