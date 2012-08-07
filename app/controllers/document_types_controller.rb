class DocumentTypesController < ApplicationController
  before_filter :signed_in_user
  before_filter :managing_admin_user

  before_filter :init, :only => [:index, :create, :update, :edit]

  def index
    @document_type = DocumentType.new
  end

  def create
    @document_type = DocumentType.new(params[:document_type])
    if @document_type.save
      flash[:success] = "DocumentType: \"" + @document_type.name + "\" added"
      redirect_to document_types_path
    else
      render 'index'
    end
  end

  def edit
    @document_type = DocumentType.find(params[:id])
  end

  def destroy
    @document_type = DocumentType.find(params[:id])
    flash[:success] = "DocumentType: \"" + @document_type.name + "\" deleted"
    @document_type.destroy
    redirect_to document_types_path
  end

  def for_publisher_id
    @document_types = DocumentType.find_all_by_publisher_id( params[:id].split(','), :include => :publisher, :order => 'publishers.name, document_types.name' )
    respond_to do |format|
      format.json {render :json => @document_types.to_json(:include => [:publisher]) }
    end
  end

  def update
    @edited_document_type = DocumentType.find(params[:id])
    @document_type = DocumentType.new
    if @edited_document_type.update_attributes(params[:document_type])
      flash[:success] = "DocumentType: \"" + @edited_document_type.name + "\" updated"
      redirect_to document_types_path
    else
      render 'index'
    end
  end


  protected

  def init
    @document_types = DocumentType.find(:all, :order => "LOWER(name)", :include => :publisher )
    @publishers = Publisher.find(:all, :order => "LOWER(name)", :include => :document_types )
  end

end



