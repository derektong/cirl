class OrganisationsController < ApplicationController
  before_filter :init, :only => [:index, :create, :edit, :update]
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @organisation = Organisation.new
  end

  def edit
    @organisation = Organisation.find(params[:id])
  end

  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      flash[:success] = "Keyword: \"" + @organisation.name + "\" saved"
      redirect_to organisations_path
    else
      render 'index'
    end
  end

  def destroy
    @organisation = Organisation.find(params[:id])
    flash[:success] = "Organisation: \"" + @organisation.name + "\" deleted"
    @organisation.destroy
    redirect_to organisations_path
  end

  def update
    @edited_organisation = Organisation.find(params[:id])
    @organisation = Organisation.new
    if @edited_organisation.update_attributes(params[:organisation])
      flash[:success] = "Organisation: \"" + @edited_organisation.name + "\" updated"
      redirect_to organisations_path
    else
      render 'index'
    end
  end

  protected

  def init
    @organisations = Organisation.find(:all, :order => "LOWER(name)" )
  end

end
