class CaseSearchesController < ApplicationController
  before_filter :correct_user,   only: [:show]
  before_filter :signed_in_or_managing_admin_user, only: [:show]
  before_filter :init, :only => [:new, :create, :edit, :update]
  before_filter :set_attributes, :only => [:show, :create, :edit, :update]

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
      if @case_search.save && current_user.save_case_search(@case_search)
        if @case_search.validate_dates
          redirect_to case_search_path(@case_search.id)
        else
          render 'new'
        end
      else
        flash[:error] = "Error in search"
        redirect_to new_case_search_path
      end
    end
  end

  def show
    @conditions = Hash.new
    @per_page = 3

    @case_name = @case_search.case_name unless @case_search.case_name.empty?
    if( @case_name )
      @conditions[:case_name] = @case_name.split(" ") 
      # don't impose a condition based on a difference between 'v' and 'vs' between parties to a case
      @conditions[:case_name].delete("v")
      @conditions[:case_name].delete("vs")
      @conditions[:case_name].delete("v.")
      @conditions[:case_name].delete("vs.")
    end

    begin
      @year_to = @case_search.year_to
      @month_to = @case_search.month_to
      @day_to = @case_search.day_to
      @year_from = @case_search.year_from
      @month_from = @case_search.month_from
      @day_from = @case_search.day_from
      date_from = Date.civil(@case_search.year_from.to_i, 
                             @case_search.month_from.to_i, 
                             @case_search.day_from.to_i)
      date_to = Date.civil(@case_search.year_to.to_i, 
                           @case_search.month_to.to_i, 
                           @case_search.day_to.to_i)
      #have to convert dates to integers to allow input of dates before 1/1/1970 (beginning of unix)
      @attributes[:decision_date] = 
        date_from.strftime("%Y%m%d").to_i..date_to.strftime("%Y%m%d").to_i if date_to >= date_from 
    rescue ArgumentError
    end

    @cases = Case.search @case_search.free_text,
             :include => [:country_origin, :court, :child_topics, 
                          :refugee_topics, :keywords],
             :with => @attributes,
             :conditions => @conditions,
             :page => params[:page], :per_page => @per_page

  end

  def edit
    @case_search.day_to = @case_search.date_to.day if @case_search.date_to != nil
    @case_search.month_to = @case_search.date_to.month if @case_search.date_to != nil
    @case_search.year_to = @case_search.date_to.year if @case_search.date_to != nil
    @case_search.day_from = @case_search.date_from.day if @case_search.date_from != nil
    @case_search.month_from = @case_search.date_from.month if @case_search.date_from != nil
    @case_search.year_from = @case_search.date_from.year if @case_search.date_from != nil
  end

  def destroy
    CaseSearch.find(params[:id]).destroy
    flash[:success] = "Search deleted."
    redirect_to user_path(current_user.id)
  end

  def update
    search = params[:case_search]
    if params[:commit].eql?('Cancel')
      redirect_to case_searches_user_path(current_user.id)
    else
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

      @case_search = CaseSearch.find(params[:id])
      if search[:name].strip.empty?
        flash[:error] = "You must enter a name"
        redirect_to :back
        return;
      end
      search[:court_ids] ||= [] if search[:court_ids]
      search[:jurisdiction_ids] ||= [] if search[:jurisdiction_ids]
      search[:country_origin_ids] ||= [] if search[:country_origin_ids]
      search[:child_topic_ids] ||= [] if search[:child_topic_ids]
      search[:refugee_topic_ids] ||= [] if search[:refugee_topic_ids]
      search[:process_topic_ids] ||= [] if search[:process_topic_ids]
      search[:keyword_ids] ||= [] if search[:keyword_ids]

      if @case_search.update_attributes(search)
        if @case_search.validate_dates
          flash[:notice] = 'Search updated.'
          redirect_to case_searches_user_path(current_user.id)
        else
          render 'edit'
        end
      else
        flash[:error] = "Error updated search"
        redirect_to user_path(current_user.id)
      end
    end
  end

  def save
    @case_search = CaseSearch.find(params[:id])
    if current_user.save_case_search(@case)
      flash[:success] = "Case: " + @case.claimant + " saved"
    else
      flash[:error] = "Cannot save case"
    end
    redirect_to :back
  end

  protected

  def init
    @courts = Court.all
    @country_origins = CountryOrigin.find(:all, :order => "LOWER(name)" )
    @jurisdictions = Jurisdiction.find(:all, :order => "LOWER(name)" )
    @refugee_topics = RefugeeTopic.find(:all, :order => "LOWER(description)" )
    @child_topics = ChildTopic.find(:all, :order => "LOWER(description)" )
    @process_topics = ProcessTopic.find(:all, :order => "LOWER(description)" )
    @keywords = Keyword.find(:all, :include => :aliases)
    @keywords_with_aliases = []
    @keywords.each do |k|
      @keywords_with_aliases += k.keywords_with_aliases
    end
    @keywords_with_aliases.sort_by!{|k|k[0]}
  end

  def set_attributes
    @case_search = CaseSearch.find(params[:id])

    @attributes = Hash.new
    @attributes[:country_origin_id] = @case_search.country_origin_ids if 
      !@case_search.country_origins.empty?
    @attributes[:court_id] = @case_search.court_ids if 
      !@case_search.courts.empty?
    @attributes[:jurisdiction_id] = @case_search.jurisdiction_ids if 
      !@case_search.jurisdictions.empty?
    @attributes[:process_topics_ids] = @case_search.process_topic_ids if 
      !@case_search.process_topics.empty?
    @attributes[:child_topics_ids] = @case_search.child_topic_ids if 
      !@case_search.child_topics.empty?
    @attributes[:refugee_topics_ids] = @case_search.refugee_topic_ids if 
      !@case_search.refugee_topics.empty?
    @attributes[:keyword_ids] = @case_search.keyword_ids if
      !@case_search.keywords.empty?
  end

  def correct_user
    @user = CaseSearch.find(params[:id]).user
    redirect_to(root_path) unless current_user?(@user) 
  end

  def signed_in_or_managing_admin_user
    @user = CaseSearch.find(params[:id]).user
    redirect_to(root_path) unless (current_user.managing_admin? || 
                                   current_user?(@user) )
  end

end
