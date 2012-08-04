class CasesController < ApplicationController
  include KeywordsHelper
  include CasesHelper

  before_filter :init, only: [:new, :edit, :create]
  before_filter :signed_in_user, only: [:new, :index, :create, :edit, :destroy,
                                        :update, :save, :for_keywords]
  before_filter :admin_user, only: [:new, :index, :create, :edit, 
                                    :destroy, :update, :for_keywords]

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
    @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
   
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
      @recommended = []
      @required = []
      render 'cases/new'
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
      params[:case][:keyword_ids] ||= []
      params[:case][:pdf] ||= ""

      if @case.update_attributes(params[:case])
        flash[:notice] = 'Case updated.'
        redirect_to cases_path 
      else
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

  def for_keywords
    @keywords = [];

    @process_ids = params[:process_ids].split(',')
    @process_ids.shift
    @processes = ProcessTopic.find(@process_ids, :include => :process_links )
    @processes.each do |process|
      @keywords += process.process_links
    end

    @child_ids = params[:child_ids].split(',')
    @child_ids.shift
    @child_topics = ChildTopic.find(@child_ids, :include => :child_links )
    @child_topics.each do |child|
      @keywords += child.child_links
    end

    @refugee_ids = params[:refugee_ids].split(',')
    @refugee_ids.shift
    @refugees = RefugeeTopic.find(@refugee_ids, :include => :refugee_links )
    @refugees.each do |refugee|
      @keywords += refugee.refugee_links
    end

    #@keywords.uniq // will not work now that whole object included

    respond_to do |format|
      format.json {render :json => @keywords.to_json }
    end
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
