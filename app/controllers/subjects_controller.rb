class SubjectsController < ApplicationController

  def index
    @subjects = Subject.all.sort_by {|a| a[:description].downcase}
    @subject = Subject.new
  end

  def edit
  end

  def create
    @subjects = Subject.all.sort_by {|a| a[:description].downcase}
    @subject = Subject.new(params[:subject])
    if @subject.save
      redirect_to subjects_path
    else
      render 'index'
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Legal subject removed."
    redirect_to subjects_path
  end

end
