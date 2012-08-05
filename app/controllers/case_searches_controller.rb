class CaseSearchesController < ApplicationController

  before_filter :init, :only => [:new, :edit]

  def new 
    @case_search = CaseSearch.new
    
    @attributes = Hash.new
    @conditions = Hash.new
    # work out whether to display advanced options or not
    params[:advanced].nil? ? @advanced_used = "none" : @advanced_used = params[:advanced]
  end
  
  def create
    search = params[:case_search]
    # there appears to be a rails bug where the first element returned is always 
    # ''. so each array is never empty
    search[:country_origin_ids].shift
    search[:jurisdiction_ids].shift
    search[:court_ids].shift
    search[:child_topic_ids].shift
    search[:refugee_topic_ids].shift
    search[:process_topic_ids].shift
    search[:keyword_ids].shift
    # get rid of aliases
    search[:keyword_ids].uniq!

    @case_search = CaseSearch.new( search )

    if @case_search.free_text.strip.empty? && 
       @case_search.case_name.strip.empty? &&
       @case_search.day_from.empty? &&
       @case_search.month_from.empty? &&
       @case_search.year_from.empty? &&
       @case_search.day_to.empty? &&
       @case_search.month_to.empty? &&
       @case_search.year_to.empty? &&
       @case_search.country_origin_ids.empty? &&
       @case_search.jurisdiction_ids.empty? &&
       @case_search.court_ids.empty? &&
       @case_search.child_topic_ids.empty? &&
       @case_search.refugee_topic_ids.empty? &&
       @case_search.process_topic_ids.empty? &&
       @case_search.keyword_ids.empty? 

      flash[:notice] = "Please complete at least one search field"
      redirect_to new_case_search_path
    else
      if @case_search.save
        if current_user.save_case_search(@case_search)
          redirect_to case_search_path(@case_search.id)
        else
          flash[:error] = "Error in search"
          redirect_to new_case_search_path
        end
      else
        flash[:error] = "Error in search"
        redirect_to new_case_search_path
      end
    end
  end

  def show
    @search = CaseSearch.find(params[:id])

    @attributes = Hash.new
    @conditions = Hash.new
    @per_page = 3

    @attributes[:country_origin_id] = @search.country_origin_ids if !@search.country_origins.empty?
    @attributes[:court_id] = @search.court_ids if !@search.courts.empty?
    @attributes[:jurisdiction_id] = @search.jurisdiction_ids if !@search.jurisdictions.empty?
    @attributes[:process_topics_ids] = @search.process_topic_ids if !@search.process_topics.empty?
    @attributes[:child_topics_ids] = @search.child_topic_ids if !@search.child_topics.empty?
    @attributes[:refugee_topics_ids] = @search.refugee_topic_ids if !@search.refugee_topics.empty?
    @attributes[:keyword_ids] = @search.keyword_ids if !@search.keywords.empty?

    @case_name = @search.case_name unless @search.case_name.empty?
    if( @case_name )
      @conditions[:case_name] = @case_name.split(" ") 
      # don't impose a condition based on a difference between 'v' and 'vs' between parties to a case
      @conditions[:case_name].delete("v")
      @conditions[:case_name].delete("vs")
      @conditions[:case_name].delete("v.")
      @conditions[:case_name].delete("vs.")
    end

    begin
      @year_to = @search.year_to
      @month_to = @search.month_to
      @day_to = @search.day_to
      @year_from = @search.year_from
      @month_from = @search.month_from
      @day_from = @search.day_from
      date_from = Date.civil(@search.year_from.to_i, 
                             @search.month_from.to_i, 
                             @search.day_from.to_i)
      date_to = Date.civil(@search.year_to.to_i, 
                           @search.month_to.to_i, 
                           @search.day_to.to_i)
      #have to convert dates to integers to allow input of dates before 1/1/1970 (beginning of unix)
      @attributes[:decision_date] = 
        date_from.strftime("%Y%m%d").to_i..date_to.strftime("%Y%m%d").to_i if date_to >= date_from 
    rescue ArgumentError
    end

    @cases = Case.search @search.free_text,
             :include => [:country_origin, :court, :child_topics, 
                          :refugee_topics, :keywords],
             :with => @attributes,
             :conditions => @conditions,
             :page => params[:page], :per_page => @per_page

  end

  def edit
    @case = Case.find(params[:id])
    @case.day = @case.decision_date.day
    @case.month = @case.decision_date.month
    @case.year = @case.decision_date.year
    @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
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
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.all
    @keywords_with_aliases = []
    @keywords.each do |k|
      @keywords_with_aliases += k.keywords_with_aliases
    end
    @keywords_with_aliases.sort_by!{|k|k[0]}
  end


end
