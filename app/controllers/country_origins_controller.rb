class CountryOriginsController < ApplicationController
  include CountryOriginsHelper

  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @country_origins = CountryOrigin.find(:all, :order => "LOWER(name)")
    @country_origin = CountryOrigin.new
  end

  def create
    @country_origins = CountryOrigin.find(:all, :order => "LOWER(name)")
    @country_origin = CountryOrigin.new(params[:country_origin])
    if @country_origin.save
      flash[:success] = "CountryOrigin: \"" + @country_origin.name + "\" added"
      redirect_to country_origins_path
    else
      render 'index'
    end
  end

  # need to refactor the validation checking. build into model?
  def destroy
    @del_country_origin = CountryOrigin.find(params[:id])
    flash[:success] = "CountryOrigin: \""+@del_country_origin.name + "\" removed"
    @del_country_origin.destroy
    redirect_to country_origins_path
  end

  def restore
    restore_country_origins
    @country_origin = CountryOrigin.new
    redirect_to country_origins_path
  end





end




