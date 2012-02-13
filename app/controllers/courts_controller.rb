class CourtsController < ApplicationController
  def index
    @courts = Court.all
    @title = "Manage Courts"
  end

  def edit
    @title = "Manage Courts"
  end
end
