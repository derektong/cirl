class JurisdictionsController < ApplicationController

  def show
    @jurisdiction = Jurisdiction.find(params[:id])
  end

  def index
    @jurisdictions = Jurisdiction.all
    @jurisdiction = Jurisdiction.new
    @title = "Manage Jurisdictions"
  end

  def edit
  end
end
