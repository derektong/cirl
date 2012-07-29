class CasesController < ApplicationController
  include KeywordsHelper

  before_filter :init, :only => [:index, :create, :new, :edit, :update]

  def new
    @case = Case.new
  end

  def index
    @attributes = Hash.new
    @conditions = Hash.new
    @per_page = 3
    # work out whether to display advanced options or not
    params[:advanced].nil? ? @advanced_used = "none" : @advanced_used = params[:advanced]

    # query whether searching for blanks should return all results
    # if( params[:search] != nil && params[:search].strip != "" )
    if( params[:search] != nil )

      @countries_origin = params[:case_country_origin]
      @attributes[:country_origin] = @countries_origin.map { |c| c.to_crc32 } if @countries_origin
      @attributes[:court_id] = params[:case_court_id] if params[:case_court_id]
      @attributes[:jurisdiction_id] = params[:case_jurisdiction_id] if params[:case_jurisdiction_id]

      @case_name = params[:case_name] unless params[:case_name].empty?
      if( @case_name )
        @conditions[:case_name] = @case_name.split(" ") 
        # don't impose a condition based on a difference between 'v' and 'vs' between parties to a case
        @conditions[:case_name].delete("v")
        @conditions[:case_name].delete("vs")
        @conditions[:case_name].delete("v.")
        @conditions[:case_name].delete("vs.")
      end

      begin
        @year_to = params[:case_year_to]
        @month_to = params[:case_month_to]
        @day_to = params[:case_day_to]
        @year_from = params[:case_year_from]
        @month_from = params[:case_month_from]
        @day_from = params[:case_day_from]
        date_from = Date.civil(params[:case_year_from].to_i, 
                               params[:case_month_from].to_i, 
                               params[:case_day_from].to_i)
        date_to = Date.civil(params[:case_year_to].to_i, 
                             params[:case_month_to].to_i, 
                             params[:case_day_to].to_i)
        #have to convert dates to integers to allow input of dates before 1/1/1970 (beginning of unix)
        @attributes[:decision_date] = 
          date_from.strftime("%Y%m%d").to_i..date_to.strftime("%Y%m%d").to_i if date_to >= date_from 
      rescue ArgumentError
      end

      @attributes[:child_topic_ids] = params[:case_child_topic_ids] if params[:case_child_topic_ids]
      @attributes[:refugee_topic_ids] = params[:case_refugee_topic_ids] if params[:case_refugee_topic_ids]
      @attributes[:keyword_ids] = params[:case_keyword_ids] if params[:case_keyword_ids]

      @cases = Case.search params[:search],
               :include => [:court, :child_topics, :refugee_topics, :keywords],
               :with => @attributes,
               :conditions => @conditions,
               :page => params[:page], :per_page => @per_page

      # if advanced options were used, always show the advanced options in the view even if user hid them
      @advanced_used = "block" unless @attributes.empty?
    end
  end

  def show
    @case = Case.find(params[:id])
  end
  
  def edit
    @case = Case.find(params[:id])
    @case.day = @case.decision_date.day
    @case.month = @case.decision_date.month
    @case.year = @case.decision_date.year
    @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
  end

  def create
    @case = Case.new(params[:case])

    if @case.save
      redirect_to cases_path
    else
      if params[:case][:jurisdiction_id] != ""
        @courts = Court.find_all_by_jurisdiction_id(params[:case][:jurisdiction_id])
        @selected_court = params[:case][:court_id]
      end
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
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :order => "LOWER(description)", :include => :aliases )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
  end


end
