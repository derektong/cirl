class SubjectsController < ApplicationController

  def index
    @subjects = Subject.find(:all, :order => 'description')
    @subject = Subject.new
  end

  def create
    @subjects = Subject.find(:all, :order => 'description')
    @subject = Subject.new(params[:subject])

    if @subject.save  
      redirect_to(subjects_path) 
    else
      render 'index'
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Legal subject removed."
    respond_to do |format|
      format.html { redirect_to subjects_path }
      format.js { render :js => "window.location = '" + subjects_path + "'" }
    end
  end

  def update
    @subjects = Subject.all.sort_by {|a| a[:description].downcase}
    @edited_subject = Subject.find(params[:id])
    @subject = Subject.new
    if @edited_subject.update_attributes(:description => params[:update_value])
      redirect_to subjects_path
    else
      render 'index'
    end
  end



end
