class SubjectsController < ApplicationController

  def index
    @subjects = Subject.all.sort_by {|a| a[:description]}
    @subject = Subject.new
    @title = "Manage Subjects"
  end

  def edit
  end

  def create
    @subjects = Subject.all.sort_by {|a| a[:description]}
    @subject = Subject.new(params[:subject])
    if @subject.save
      redirect_to subject_path
    else
      @title = "Manage Subjects"
      render 'index'
    end
  end

end
