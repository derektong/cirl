class IssuesController < ApplicationController
  def index
    @issues = Issue.all.sort_by {|a| a[:description].downcase}
    @issue = Issue.new
    @title = "Manage Issues"
  end

  def edit
  end

  def create
    @issues = Issue.all.sort_by {|a| a[:description].downcase}
    @issue = Issue.new(params[:issue])
    if @issue.save
      redirect_to issue_path
    else
      @title = "Manage Issues"
      render 'index'
    end
  end

end
