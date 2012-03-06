class CasesController < ApplicationController

  def new
    @courts = Court.all
    @jurisdictions = Jurisdiction.find(:all, :order => :name )
    @issues = Issue.find(:all, :order => :description )
    @subjects = Subject.find(:all, :order => :description )
    @case = Case.new
  end

  def index
    @courts = Court.all
    @jurisdictions = Jurisdiction.all
    @issues = Issue.all
    @subjects = Subject.all
    # query whether searching for blanks should return all results
    # if( params[:search] != nil && params[:search].strip != "" )
    if( params[:search] != nil )
      @conditions = Hash.new
      if( params[:case_country_origin] != nil )
        @conditions[:country_origin] = params[:case_country_origin]
      end

      @attributes_single = Hash.new
      if( params[:case_court_id] != nil )
        @attributes_single[:court_id] = params[:case_court_id] 
      end
      if( params[:case_jurisdiction_id] != nil )
        @attributes_single[:jurisdiction_id] = params[:case_jurisdiction_id] 
      end
      #begin
      #  Date date_from = Date.civil(:

      @attributes_multiple = Hash.new
      if( params[:case_subject_ids] != nil )
        @attributes_multiple[:subject_ids] = params[:case_subject_ids] 
      end
      if( params[:case_issue_ids] != nil )
        @attributes_multiple[:issue_ids] = params[:case_issue_ids] 
      end

      @cases = Case.search params[:search],
               :include => [:court, :subjects, :issues],
               :conditions => @conditions,
               :with => @attributes_single,
               :with_all => @attributes_multiple
    end

  end

  def show
    redirect_to cases_path
  end
  
  def edit
    @case = Case.find(params[:id])
    @case.day = @case.decision_date.day
    @case.month = @case.decision_date.month
    @case.year = @case.decision_date.year
    @case.jurisdiction_id = Court.find(@case.court_id).jurisdiction_id
    @courts = Court.find_all_by_jurisdiction_id(@case.jurisdiction_id)
    @jurisdictions = Jurisdiction.find(:all, :order => :name )
    @issues = Issue.find(:all, :order => :description )
    @subjects = Subject.find(:all, :order => :description )
  end

  def create
    @cases = Case.find(:all, :order => ':claimant, :respondent' )
    @case = Case.new(params[:case])

    if @case.save
      redirect_to cases_path
    else
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
      params[:case][:subject_ids] ||= []
      params[:case][:issue_ids] ||= []
      if @case.update_attributes(params[:case])
        flash[:notice] = 'Case updated.'
        redirect_to cases_path
      else
        render 'edit'
      end
    end
  end


end
