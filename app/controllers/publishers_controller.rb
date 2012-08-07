class PublishersController < ApplicationController
  before_filter :init, :only => [:index, :create, :edit, :update, :destroy]
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @publisher = Publisher.new
  end

  def edit
    @publisher = Publisher.find(params[:id])
  end

  def create
    @publisher = Publisher.new(params[:publisher])
    if @publisher.save
      flash[:success] = "Keyword: \"" + @publisher.name + "\" saved"
      redirect_to publishers_path
    else
      render 'index'
    end
  end

  def destroy
    @del_publisher = Publisher.find(params[:id])
    begin
      @del_publisher.destroy
      flash[:success] = "publisher: \""+ @del_publisher.name + "\" removed"
      redirect_to publishers_path
    rescue ActiveRecord::DeleteRestrictionError
      @del_publisher.errors.add(:base, 
                                   "Cannot delete when there are linked document types")
      @publisher = Publisher.new
      render 'index', :del_publisher => @del_publisher
    end
  end

  def update
    @edited_publisher = Publisher.find(params[:id])
    @publisher = Publisher.new
    if @edited_publisher.update_attributes(params[:publisher])
      flash[:success] = "Publisher: \"" + @edited_publisher.name + "\" updated"
      redirect_to publishers_path
    else
      render 'index'
    end
  end

  protected

  def init
    @publishers = Publisher.find(:all, :order => "LOWER(name)" )
  end

end
