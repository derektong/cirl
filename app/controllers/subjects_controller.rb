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

    respond_to do |format|
      if @subject.save  
        format.html { redirect_to(subjects_path 
                      :notice => 'Legal subject added') }
        format.js
      else
        format.html { render :action => "index" }
        format.js
      end
    end
  end

  def destroy
    Subject.find(params[:id]).destroy
    flash[:success] = "Legal subject removed."
    redirect_to subjects_path
  end

end
