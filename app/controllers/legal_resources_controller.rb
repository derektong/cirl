class LegalResourcesController < ApplicationController
  include KeywordsHelper

  before_filter :init, only: [:new, :edit, :create, :update]
  before_filter :signed_in_user, only: [:new, :index, :create, :edit, :destroy,
                                        :update, :save, :unsave]
  before_filter :admin_user, only: [:new, :index, :create, :edit, 
                                    :destroy, :update]

  def new
    @legal_resource = LegalResource.new
    @recommended = []
    @required = []
  end

  def index
    @legal_resources = LegalResource.paginate(page: params[:page], per_page: 5)
  end

  def show
    begin
      @legal_resource = LegalResource.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #what to do when legal_resource is not found
      redirect_to root_path
    end
  end
  
  def edit
    @legal_resource = LegalResource.find(params[:id])
    @legal_resource.day = @legal_resource.document_date.day
    @legal_resource.month = @legal_resource.document_date.month
    @legal_resource.year = @legal_resource.document_date.year

    # error handling if document_types have been deleted etc.
    begin
      @legal_resource.publisher_id = DocumentType.find(@legal_resource.document_type_id).publisher_id
      @document_types = DocumentType.find_all_by_publisher_id(@legal_resource.publisher_id)
    rescue ActiveRecord::RecordNotFound
      @legal_resource.document_type = DocumentType.new
    end
  
    @selected_process_topics = ProcessTopic.find( @legal_resource.process_topic_ids )
    @selected_child_topics = ChildTopic.find( @legal_resource.child_topic_ids )
    @selected_refugee_topics = RefugeeTopic.find( @legal_resource.refugee_topic_ids )
    keyword_links = get_links( @selected_process_topics,
                               @selected_child_topics, 
                               @selected_refugee_topics )
    @recommended = keyword_links[0]
    @required = keyword_links[1]
  end

  def create
    @legal_resource = LegalResource.new(params[:legal_resource])

    if @legal_resource.save
      @legal_resource.rename_pdf
      redirect_to legal_resources_path
    else
      if params[:legal_resource][:publisher_id] != ""
        @document_types = DocumentType.find_all_by_publisher_id(params[:legal_resource][:publisher_id])
        @selected_document_type = params[:legal_resource][:document_type_id]
      end
      @selected_process_topics = ProcessTopic.find( params[:legal_resource][:process_topic_ids] ) if
        params[:legal_resource][:process_topic_ids]
      @selected_child_topics = ChildTopic.find( params[:legal_resource][:child_topic_ids] ) if
        params[:legal_resource][:child_topic_ids]
      @selected_refugee_topics = RefugeeTopic.find( params[:legal_resource][:refugee_topic_ids] ) if
        params[:legal_resource][:refugee_topic_ids]
      keyword_links = get_links( @selected_process_topics,
                                 @selected_child_topics, 
                                 @selected_refugee_topics )
      @recommended = keyword_links[0]
      @required = keyword_links[1]
      render 'new'
    end
  end

  def destroy
    LegalResource.find(params[:id]).destroy
    flash[:success] = "LegalResource removed."
    redirect_to legal_resources_path
  end

  def update
    if params[:commit].eql?('Cancel')
      redirect_to legal_resources_path 
    else
      @legal_resource = LegalResource.find(params[:id])
      params[:legal_resource][:child_topic_ids] ||= []
      params[:legal_resource][:refugee_topic_ids] ||= []
      params[:legal_resource][:process_topic_ids] ||= []
      params[:legal_resource][:keyword_ids] ||= []
      params[:legal_resource][:pdf] ||= ""

      if @legal_resource.update_attributes(params[:legal_resource])
        flash[:notice] = 'LegalResource updated.'
        redirect_to legal_resources_path 
      else
        @recommended = []
        @required = []
        render 'edit'
      end
    end
  end

  def save
    @legal_resource = LegalResource.find(params[:id])
    if current_user.save_legal_resource(@legal_resource)
      flash[:success] = "LegalResource: " + @legal_resource.name + " saved"
    else
      flash[:error] = "Cannot save legal_resource"
    end
    redirect_to :back
  end

  def unsave
    @legal_resource = LegalResource.find(params[:id])
    if current_user.unsave_legal_resource(@legal_resource)
      flash[:success] = "LegalResource: " + @legal_resource.name + " removed"
    else
      flash[:error] = "Cannot remove legal_resource"
    end
    redirect_to :back
  end

  def import
  end

  protected

  def init
    @document_types = DocumentType.all
    @publishers = Publisher.find(:all, :order => "LOWER(name)" )
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :order => "LOWER(description)", 
                             :include => :aliases )
  end


end
