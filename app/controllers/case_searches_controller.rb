class CaseSearchesController < ApplicationController

  before_filter :init, :only => [:index, :create, :new, :edit, :update]

  def new
    @case_search = CaseSearch.new
    @attributes = Hash.new
    @conditions = Hash.new
    # work out whether to display advanced options or not
    params[:advanced].nil? ? @advanced_used = "none" : @advanced_used = params[:advanced]
  end
  
  def create
    @attributes = Hash.new
    @conditions = Hash.new
    @per_page = 3
    # query whether searching for blanks should return all results
    # if( params[:search] != nil && params[:search].strip != "" )
    if( params[:case_search] != nil )
      search = params[:case_search]

      # there appears to be a rails bug where the first element returned is always 
      # ''. so the array is never empty
      search[:country_origins].shift
      search[:jurisdictions].shift
      search[:courts].shift
      search[:child_topics].shift
      search[:refugee_topics].shift
      search[:process_topics].shift
      search[:keywords].shift

      @attributes[:country_origin_id] = search[:country_origins] if !search[:country_origins].empty?
      @attributes[:court_id] = search[:courts] if !search[:courts].empty?
      @attributes[:jurisdiction_id] = search[:jurisdictions] if !search[:jurisdictions].empty?
      @attributes[:process_topic_ids] = search[:process_topics] if !search[:process_topics].empty?
      @attributes[:child_topic_ids] = search[:child_topics] if !search[:child_topics].empty?
      @attributes[:refugee_topic_ids] = search[:refugee_topics] if !search[:refugee_topics].empty?
      @attributes[:keyword_ids] = search[:keywords] if !search[:keywords].empty?

      @case_name = search[:case_name] unless search[:case_name].empty?
      if( @case_name )
        @conditions[:case_name] = @case_name.split(" ") 
        # don't impose a condition based on a difference between 'v' and 'vs' between parties to a case
        @conditions[:case_name].delete("v")
        @conditions[:case_name].delete("vs")
        @conditions[:case_name].delete("v.")
        @conditions[:case_name].delete("vs.")
      end

      begin
        @year_to = params[:year_to]
        @month_to = params[:month_to]
        @day_to = params[:day_to]
        @year_from = params[:year_from]
        @month_from = params[:month_from]
        @day_from = params[:day_from]
        date_from = Date.civil(params[:year_from].to_i, 
                               params[:month_from].to_i, 
                               params[:day_from].to_i)
        date_to = Date.civil(params[:year_to].to_i, 
                             params[:month_to].to_i, 
                             params[:day_to].to_i)
        #have to convert dates to integers to allow input of dates before 1/1/1970 (beginning of unix)
        @attributes[:decision_date] = 
          date_from.strftime("%Y%m%d").to_i..date_to.strftime("%Y%m%d").to_i if date_to >= date_from 
      rescue ArgumentError
      end

      @cases = Case.search search[:free_text],
               :include => [:country_origin, :court, :child_topics, 
                            :refugee_topics, :keywords],
               :with => @attributes,
               :conditions => @conditions,
               :page => params[:page], :per_page => @per_page

      render 'results'
    end
  end

  def index
  end

  def show
  end
  
  def edit
    @case = Case.find(params[:id])
    @case.day = @case.decision_date.day
    @case.month = @case.decision_date.month
    @case.year = @case.decision_date.year
    @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
  end

  def create2
    @search = CaseSearch.new(params[:case_search])

    if @search.save
      redirect_to results_case_searches_path
    else
      if params[:free_text][:jurisdiction_id] != ""
        @courts = Court.find_all_by_jurisdiction_id(params[:case_search][:jurisdiction_id])
        @selected_court = params[:case_search][:court_id]
      end
      render 'new'
    end
  end

  def destroy
    Search.find(params[:id]).destroy
    flash[:success] = "Search deleted."
    redirect_to searches_path
  end

  def update
    if params[:commit].eql?('Cancel')
      redirect_to case_searches_path 
    else
      @search = CaseSearch.find(params[:id])
      params[:case_search][:child_topic_ids] ||= []
      params[:case_search][:refugee_topic_ids] ||= []
      params[:case_search][:process_topic_ids] ||= []
      params[:case_search][:keyword_ids] ||= []

      if @search.update_attributes(params[:search])
        flash[:notice] = 'Search updated.'
        redirect_to cases_searches_path 
      else
        render 'edit'
      end
    end
  end

  protected

  def init
    @courts = Court.all
    @country_origins = CountryOrigin.find(:all, :order => "LOWER(name)" )
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)" )
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :order => "LOWER(description)", :include => :aliases )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
  end


end