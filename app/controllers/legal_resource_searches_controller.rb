 class LegalResourceSearchesController < ApplicationController
  before_filter :correct_user,   only: [:show]
  before_filter :signed_in_or_managing_admin_user, only: [:show]
  before_filter :init, :only => [:new, :create, :edit, :update]

  def new 
    @legal_resource_search = LegalResourceSearch.new
    
    @attributes = Hash.new
    @conditions = Hash.new
    # work out whether to display advanced options or not
    params[:advanced].nil? ? @advanced_used = "none" : @advanced_used = params[:advanced]
  end
  
  def create
    search = params[:legal_resource_search]
    # there appears to be a rails bug where the first element returned is always 
    # ''. so each array is never empty
    search[:publisher_ids].shift
    search[:document_type_ids].shift
    search[:child_topic_ids].shift
    search[:refugee_topic_ids].shift
    search[:process_topic_ids].shift
    search[:keyword_ids].shift
    # get rid of aliases
    search[:keyword_ids].uniq!

    @legal_resource_search = LegalResourceSearch.new( search )
    set_attributes 

    if @legal_resource_search.free_text.strip.empty? && 
       @legal_resource_search.legal_resource_name.strip.empty? &&
       @legal_resource_search.day_from.empty? &&
       @legal_resource_search.month_from.empty? &&
       @legal_resource_search.year_from.empty? &&
       @legal_resource_search.day_to.empty? &&
       @legal_resource_search.month_to.empty? &&
       @legal_resource_search.year_to.empty? &&
       @legal_resource_search.publisher_ids.empty? &&
       @legal_resource_search.document_type_ids.empty? &&
       @legal_resource_search.child_topic_ids.empty? &&
       @legal_resource_search.refugee_topic_ids.empty? &&
       @legal_resource_search.process_topic_ids.empty? &&
       @legal_resource_search.keyword_ids.empty? 

      flash[:notice] = "Please complete at least one search field"
      redirect_to new_legal_resource_search_path
    else
      if @legal_resource_search.save && current_user.save_legal_resource_search(@legal_resource_search)
        if @legal_resource_search.validate_dates
          redirect_to legal_resource_search_path(@legal_resource_search.id)
        else
          render 'new'
        end
      else
        flash[:error] = "Error in search"
        redirect_to new_legal_resource_search_path
      end
    end
  end

  def show
    @conditions = Hash.new
    @per_page = params[:per_page] || 10

    @legal_resource_search = LegalResourceSearch.find(params[:id])
    set_attributes
    @legal_resource_name = @legal_resource_search.legal_resource_name unless @legal_resource_search.legal_resource_name.empty?

    begin
      @year_to = @legal_resource_search.year_to
      @month_to = @legal_resource_search.month_to
      @day_to = @legal_resource_search.day_to
      @year_from = @legal_resource_search.year_from
      @month_from = @legal_resource_search.month_from
      @day_from = @legal_resource_search.day_from
      date_from = Date.civil(@legal_resource_search.year_from.to_i, 
                             @legal_resource_search.month_from.to_i, 
                             @legal_resource_search.day_from.to_i)
      date_to = Date.civil(@legal_resource_search.year_to.to_i, 
                           @legal_resource_search.month_to.to_i, 
                           @legal_resource_search.day_to.to_i)
      #have to convert dates to integers to allow input of dates before 1/1/1970 (beginning of unix)
      @attributes[:decision_date] = 
        date_from.strftime("%Y%m%d").to_i..date_to.strftime("%Y%m%d").to_i if date_to >= date_from 
    rescue ArgumentError
    end

    @legal_resources = LegalResource.search @legal_resource_search.free_text,
             :include => [:document_type, :child_topics, :process_topics,
                          :refugee_topics, :keywords],
             :with => @attributes,
             :conditions => @conditions,
             :page => params[:page], :per_page => @per_page

  end

  def edit
    @legal_resource_search = LegalResourceSearch.find(params[:id])
    set_attributes
    @legal_resource_search.day_to = @legal_resource_search.date_to.day if @legal_resource_search.date_to != nil
    @legal_resource_search.month_to = @legal_resource_search.date_to.month if @legal_resource_search.date_to != nil
    @legal_resource_search.year_to = @legal_resource_search.date_to.year if @legal_resource_search.date_to != nil
    @legal_resource_search.day_from = @legal_resource_search.date_from.day if @legal_resource_search.date_from != nil
    @legal_resource_search.month_from = @legal_resource_search.date_from.month if @legal_resource_search.date_from != nil
    @legal_resource_search.year_from = @legal_resource_search.date_from.year if @legal_resource_search.date_from != nil
  end

  def destroy
    LegalResourceSearch.find(params[:id]).destroy
    flash[:success] = "Search deleted."
    redirect_to user_path(current_user.id)
  end

  def update
    search = params[:legal_resource_search]
    if params[:commit].eql?('Cancel')
      redirect_to legal_resource_searches_user_path(current_user.id)
    else

      # there appears to be a rails bug where the first element returned is always 
      # ''. so each array is never empty
      search[:publisher_ids].shift
      search[:document_type_ids].shift
      search[:child_topic_ids].shift
      search[:refugee_topic_ids].shift
      search[:process_topic_ids].shift
      search[:keyword_ids].shift
      # get rid of aliases
      search[:keyword_ids].uniq!

      @legal_resource_search = LegalResourceSearch.find(params[:id])
      set_attributes
      if search[:name].strip.empty?
        flash[:error] = "You must enter a name"
        redirect_to :back
        return;
      end
      search[:document_type_ids] ||= [] if search[:document_type_ids]
      search[:publisher_ids] ||= [] if search[:publisher_ids]
      search[:child_topic_ids] ||= [] if search[:child_topic_ids]
      search[:refugee_topic_ids] ||= [] if search[:refugee_topic_ids]
      search[:process_topic_ids] ||= [] if search[:process_topic_ids]
      search[:keyword_ids] ||= [] if search[:keyword_ids]

      if @legal_resource_search.update_attributes(search)
        if @legal_resource_search.validate_dates
          flash[:notice] = 'Search updated.'
          redirect_to legal_resource_searches_user_path(current_user.id)
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
    @legal_resource_search = LegalResourceSearch.find(params[:id])
    if current_user.save_legal_resource_search(@legal_resource)
      flash[:success] = "LegalResource: " + @legal_resource.name + " saved"
    else
      flash[:error] = "Cannot save legal_resource"
    end
    redirect_to :back
  end

  protected

  def init
    @document_types = DocumentType.all
    @publishers = Publisher.find(:all, :order => "LOWER(name)" )
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

    @attributes = Hash.new
    @attributes[:document_type_id] = @legal_resource_search.document_type_ids if 
      !@legal_resource_search.document_types.empty?
    @attributes[:publisher_id] = @legal_resource_search.publisher_ids if 
      !@legal_resource_search.publishers.empty?
    @attributes[:process_topics_ids] = @legal_resource_search.process_topic_ids if 
      !@legal_resource_search.process_topics.empty?
    @attributes[:child_topics_ids] = @legal_resource_search.child_topic_ids if 
      !@legal_resource_search.child_topics.empty?
    @attributes[:refugee_topics_ids] = @legal_resource_search.refugee_topic_ids if 
      !@legal_resource_search.refugee_topics.empty?
    @attributes[:keyword_ids] = @legal_resource_search.keyword_ids if
      !@legal_resource_search.keywords.empty?
  end

  def correct_user
    @user = LegalResourceSearch.find(params[:id]).user
    redirect_to(root_path) unless current_user?(@user) 
  end

  def signed_in_or_managing_admin_user
    @user = LegalResourceSearch.find(params[:id]).user
    redirect_to(root_path) unless (current_user.managing_admin? || 
                                   current_user?(@user) )
  end

end
