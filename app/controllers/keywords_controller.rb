class KeywordsController < ApplicationController
  before_filter :init, :only => [:index, :create, :edit, :update]
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @keyword = Keyword.new
    @alias = Alias.new
  end

  def edit
    @keyword = Keyword.find(params[:id])
  end

  def create
    @keyword = Keyword.new(params[:keyword])
    if @keyword.save
      redirect_to keywords_path
    else
      render 'index'
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])
    flash[:success] = "Keyword: \"" + @keyword.description + "\" deleted"
    @keyword.destroy
    redirect_to keywords_path
  end

  def update
    @edited_keyword = Keyword.find(params[:id])
    @keyword = Keyword.new
    if @edited_keyword.update_attributes(params[:keyword])
      flash[:success] = "Keyword: \"" + @edited_keyword.description + "\" updated"
      redirect_to keywords_path
    else
      render 'index'
    end
  end

  def refresh_keywords
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


  protected

  def init
    @keywords = Keyword.find(:all, :order => "LOWER(description)", include: :aliases )
  end

end
