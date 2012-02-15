class CourtsController < ApplicationController
  def index
    @courts = Court.all
  end

  def edit
  end
end
