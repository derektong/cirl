class IssuesController < ApplicationController
  def list
    @issues = Issue.all
    @issue = Issue.new
    @title = "Manage Issues"
  end

  def edit
  end
end
