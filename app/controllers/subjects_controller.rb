class SubjectsController < ApplicationController

  def index
    @subjects = Subject.all.sort_by {|a| a[:description].downcase}
    @subject = Subject.new
    @title = "Manage Subjects"
  end

  def edit
  end

  def show
  end

  def create
    @subjects = Subject.all.sort_by {|a| a[:description].downcase}
    @subject = Subject.new(params[:subject])
    if @subject.save
      redirect_to subject_path
    else
      @title = "Manage Subjects"
      render 'index'
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Legal subject removed."
    redirect_to subject_path
  end

end
