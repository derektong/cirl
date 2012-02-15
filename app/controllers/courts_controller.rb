class CourtsController < ApplicationController

  def index
    @courts = Court.all
    @court = Court.new
  end

  def create
    @courts = Court.all.sort_by {|a| a[:name].downcase}
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


end
