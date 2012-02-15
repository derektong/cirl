class IssuesController < ApplicationController
  def index
    @issues = Issue.all.sort_by {|a| a[:description].downcase}
    @issue = Issue.new
  end

  def edit
  end

  def create
    @issues = Issue.all.sort_by {|a| a[:description].downcase}
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
  end

end
