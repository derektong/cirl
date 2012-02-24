class IssuesController < ApplicationController
  def index
    @issues = Issue.find(:all, :order => :description )
    @issue = Issue.new
  end

  def create
    @issues = Issue.find(:all, :order => :description )
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect_to issues_path
    else
      render 'index'
    end
  end

  def destroy
    Issue.find(params[:id]).destroy
    flash[:success] = "Legal issue removed."
    redirect_to issues_path
    respond_to do |format|
      format.html { redirect_to issues_path }
      format.js { render :js => "window.location = '" + issues_path + "'" }
    end
  end

  def update
    @issues = Issue.all.sort_by {|a| a[:description].downcase}
    @edited_issue = Issue.find(params[:id])
    @issue = Issue.new
    if @edited_issue.update_attributes(:description => params[:update_value])
      redirect_to issues_path
    else
      render 'index'
    end
  end

end
