class LegalBriefsController < ApplicationController
  include KeywordsHelper

  before_filter :init, only: [:new, :edit, :create, :update]
  before_filter :signed_in_user, only: [:new, :create, :edit, :destroy,
                                        :update, :save, :unsave]
  before_filter :correct_user, only: [:edit, :destroy, :update]

  def new
    @legal_brief = LegalBrief.new
    @recommended = []
    @required = []
  end

  def index
    @legal_briefs = LegalBrief.paginate(page: params[:page], per_page: 5)
  end

  def show
    begin
      @legal_brief = LegalBrief.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #what to do when legal_brief is not found
      redirect_to root_path
    end
  end
  
  def edit
    @legal_brief = LegalBrief.find(params[:id])
    @legal_brief.day = @legal_brief.document_date.day
    @legal_brief.month = @legal_brief.document_date.month
    @legal_brief.year = @legal_brief.document_date.year

    # error handling if courts have been deleted etc.
    begin
      @legal_brief.jurisdiction_id = Court.find(@legal_brief.court_id).jurisdiction_id
      @courts = Court.find_all_by_jurisdiction_id(@legal_brief.jurisdiction_id)
    rescue ActiveRecord::RecordNotFound
      @legal_brief.court = Court.new
    end
  
    # error handling if organisations have changed
    begin
      @legal_brief.organisation = Organisation.find(@legal_brief.organisation_id)
    rescue ActiveRecord::RecordNotFound
      @legal_brief.organisation = Organisation.new
    end
   
    @selected_process_topics = ProcessTopic.find( @legal_brief.process_topic_ids )
    @selected_child_topics = ChildTopic.find( @legal_brief.child_topic_ids )
    @selected_refugee_topics = RefugeeTopic.find( @legal_brief.refugee_topic_ids )
    keyword_links = get_links( @selected_process_topics,
                               @selected_child_topics, 
                               @selected_refugee_topics )
    @recommended = keyword_links[0]
    @required = keyword_links[1]
  end

  def create
    @legal_brief = LegalBrief.new(params[:legal_brief])
    @legal_brief.user_id = current_user.id

    if @legal_brief.save
      @legal_brief.rename_pdf
      redirect_to legal_briefs_path
    else
      if params[:legal_brief][:jurisdiction_id] != ""
        @courts = Court.find_all_by_jurisdiction_id(params[:legal_brief][:jurisdiction_id])
        @selected_court = params[:legal_brief][:court_id]
      end
      @selected_process_topics = ProcessTopic.find( params[:legal_brief][:process_topic_ids] ) if
        params[:legal_brief][:process_topic_ids]
      @selected_child_topics = ChildTopic.find( params[:legal_brief][:child_topic_ids] ) if
        params[:legal_brief][:child_topic_ids]
      @selected_refugee_topics = RefugeeTopic.find( params[:legal_brief][:refugee_topic_ids] ) if
        params[:legal_brief][:refugee_topic_ids]
      keyword_links = get_links( @selected_process_topics,
                                 @selected_child_topics, 
                                 @selected_refugee_topics )
      @recommended = keyword_links[0]
      @required = keyword_links[1]
      render 'new'
    end
  end

  def destroy
    LegalBrief.find(params[:id]).destroy
    flash[:success] = "LegalBrief removed."
    redirect_to legal_briefs_path
  end

  def update
    if params[:commit].eql?('Cancel')
      redirect_to legal_briefs_path 
    else
      @legal_brief = LegalBrief.find(params[:id])
      params[:legal_brief][:child_topic_ids] ||= []
      params[:legal_brief][:refugee_topic_ids] ||= []
      params[:legal_brief][:process_topic_ids] ||= []
      params[:legal_brief][:keyword_ids] ||= []
      params[:legal_brief][:pdf] ||= ""

      if @legal_brief.update_attributes(params[:legal_brief])
        flash[:notice] = 'LegalBrief updated.'
        redirect_to legal_briefs_path 
      else
        @recommended = []
        @required = []
        render 'edit'
      end
    end
  end

  def save
    @legal_brief = LegalBrief.find(params[:id])
    if current_user.save_legal_brief(@legal_brief)
      flash[:success] = "LegalBrief: " + @legal_brief.name + " saved"
    else
      flash[:error] = "Cannot save legal_brief"
    end
    redirect_to :back
  end

  def unsave
    @legal_brief = LegalBrief.find(params[:id])
    if current_user.unsave_legal_brief(@legal_brief)
      flash[:success] = "LegalBrief: " + @legal_brief.name + " removed"
    else
      flash[:error] = "Cannot remove legal_brief"
    end
    redirect_to :back
  end

  def import
  end

  protected

  def init
    @courts = Court.all
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)" )
    @organisations = Organisation.find(:all, :order => "LOWER(name)" )
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :order => "LOWER(description)", 
                             :include => :aliases )
  end

  def correct_user
    @user = LegalBrief.find(params[:id]).user
    redirect_to(root_path) unless current_user?(@user) || current_user.managing_admin?
  end


end
