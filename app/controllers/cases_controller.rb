class CasesController < ApplicationController
  include KeywordsHelper

  before_filter :init, only: [:new, :edit, :create, :update]
  before_filter :signed_in_user, only: [:new, :index, :create, :edit, :destroy,
                                        :update, :save, :unsave]
  before_filter :admin_user, only: [:new, :index, :create, :edit, 
                                    :destroy, :update]

  def new
    @case = Case.new
    @recommended = []
    @required = []
  end

  def index
    @cases = Case.paginate(page: params[:page], per_page: 5)
  end

  def show
    begin
      @case = Case.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #what to do when case is not found
      redirect_to root_path
    end
  end
  
  def edit
    @case = Case.find(params[:id])
    @case.day = @case.decision_date.day
    @case.month = @case.decision_date.month
    @case.year = @case.decision_date.year

    # error handling if courts have been deleted etc.
    begin
      @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
      @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
    rescue ActiveRecord::RecordNotFound
      @case.court = Court.new
    end
  
    # error handling if countries of origin have changed
    begin
      @case.country_origin = CountryOrigin.find(@case.country_origin_id)
    rescue ActiveRecord::RecordNotFound
      @case.country_origin = CountryOrigin.new
    end
   
    @selected_process_topics = ProcessTopic.find( @case.process_topic_ids )
    @selected_child_topics = ChildTopic.find( @case.child_topic_ids )
    @selected_refugee_topics = RefugeeTopic.find( @case.refugee_topic_ids )
    keyword_links = get_links( @selected_process_topics,
                               @selected_child_topics, 
                               @selected_refugee_topics )
    @recommended = keyword_links[0]
    @required = keyword_links[1]
  end

  def create
    @case = Case.new(params[:case])

    if @case.save
      @case.rename_pdf
      redirect_to cases_path
    else
      if params[:case][:jurisdiction_id] != ""
        @courts = Court.find_all_by_jurisdiction_id(params[:case][:jurisdiction_id])
        @selected_court = params[:case][:court_id]
      end
      @selected_process_topics = ProcessTopic.find( params[:case][:process_topic_ids] ) if
        params[:case][:process_topic_ids]
      @selected_child_topics = ChildTopic.find( params[:case][:child_topic_ids] ) if
        params[:case][:child_topic_ids]
      @selected_refugee_topics = RefugeeTopic.find( params[:case][:refugee_topic_ids] ) if
        params[:case][:refugee_topic_ids]
      keyword_links = get_links( @selected_process_topics,
                                 @selected_child_topics, 
                                 @selected_refugee_topics )
      @recommended = keyword_links[0]
      @required = keyword_links[1]
      render 'new'
    end
  end

  def destroy
    Case.find(params[:id]).destroy
    flash[:success] = "Case removed."
    redirect_to cases_path
  end

  def update
    if params[:commit].eql?('Cancel')
      redirect_to cases_path 
    else
      @case = Case.find(params[:id])
      params[:case][:child_topic_ids] ||= []
      params[:case][:refugee_topic_ids] ||= []
      params[:case][:process_topic_ids] ||= []
      params[:case][:keyword_ids] ||= []
      params[:case][:pdf] ||= ""

      if @case.update_attributes(params[:case])
        flash[:notice] = 'Case updated.'
        redirect_to cases_path 
      else
        @recommended = []
        @required = []
        render 'edit'
      end
    end
  end

  def save
    @case = Case.find(params[:id])
    if current_user.save_case(@case)
      flash[:success] = "Case: " + @case.claimant + " saved"
    else
      flash[:error] = "Cannot save case"
    end
    redirect_to :back
  end

  def unsave
    @case = Case.find(params[:id])
    if current_user.unsave_case(@case)
      flash[:success] = "Case: " + @case.claimant + " removed"
    else
      flash[:error] = "Cannot remove case"
    end
    redirect_to :back
  end

  def import
  end

  protected

  def init
    @courts = Court.all
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)" )
    @country_origins = CountryOrigin.find(:all, :order => "LOWER(name)" )
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :order => "LOWER(description)", 
                             :include => :aliases )
  end


end
