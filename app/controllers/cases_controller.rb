class CasesController < ApplicationController

  before_filter :init, :only => [:index, :create, :new, :edit, :update]

  def new
    @case = Case.new
  end

  def index
    @advanced_used = "none"
    @attributes = Hash.new
    @conditions = Hash.new
    # query whether searching for blanks should return all results
    # if( params[:search] != nil && params[:search].strip != "" )
    if( params[:search] != nil )

      @conditions[:country_origin] = params[:case_country_origin] unless params[:case_country_origin].nil? 
      @attributes[:court_id] = params[:case_court_id] unless params[:case_court_id].nil? 
      @attributes[:jurisdiction_id] = params[:case_jurisdiction_id] unless params[:case_jurisdiction_id].nil? 

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

      @attributes[:child_topic_ids] = params[:case_child_topic_ids] unless params[:case_child_topic_ids].nil?
      @attributes[:refugee_topic_ids] = params[:case_refugee_topic_ids] unless params[:case_refugee_topic_ids].nil? 

      @cases = Case.search params[:search],
               :include => [:court, :child_topics, :refugee_topics],
               :conditions => @conditions,
               :with => @attributes

      @attributes.empty? && @conditions.empty? ? @advanced_used = "none" : @advanced_used = "block"
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
      params[:case][:pdf] ||= ""

      if @case.update_attributes(params[:case])
        flash[:notice] = 'Case updated.'
        redirect_to cases_path 
      else
        render 'edit'
      end
    end
  end

  protected

  def init
    @courts = Court.all
    @jurisdictions = Jurisdiction.find(:all, :order => :name )
    @refugee_topics = RefugeeTopic.find(:all, :order => :description )
    @child_topics = ChildTopic.find(:all, :order => :description )
  end


end
