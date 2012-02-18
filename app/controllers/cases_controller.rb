class CasesController < ApplicationController

  def new
    @cases = Case.all
    @case = Case.new
  end

  def index
    @cases = Case.all 
  end

  def show
    @case = Case.find(params[:id])
  end

  def create
    @cases = Case.all.sort_by {|a| a[:claimant].downcase}
    @case = Case.new(params[:case])
    if @case.save
      redirect_to @case
    else
      render 'new'
    end
  end

  def destroy
    Case.find(params[:id]).destroy
    flash[:success] = "Case removed."
    redirect_to cases_path
  end

  def update
    params[:case][:subject_ids] || []
  end


end
