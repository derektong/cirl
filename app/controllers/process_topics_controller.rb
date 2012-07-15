class ProcessTopicsController < ApplicationController
  #include ProcessTopicsHelper

  before_filter :init, :only => [:index, :create, :edit, :update, :restore, 
                                 :create_link]

  def index
    @process_topic = ProcessTopic.new
    @process_link = ProcessLink.new
    @keywords = Keyword.find(:all, :order => :description )
  end

  def edit
    @process_topic = ProcessTopic.find(params[:id])
  end

  def create
    @process_topic = ProcessTopic.new(params[:process_topic])
    @process_link = ProcessLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @process_topic.save
      redirect_to process_topics_path
    else
      render 'index'
    end
  end

  def destroy
    @process_topic = ProcessTopic.find(params[:id])
    flash[:success] = "Process topic: \"" + @process_topic.description + "\" deleted"
    @process_topic.destroy
    redirect_to process_topics_path
  end

  def update
    @edited_process_topic = ProcessTopic.find(params[:id])
    @process_topic = ProcessTopic.new
    @process_link = ProcessLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @edited_process_topic.update_attributes(params[:process_topic])
      flash[:success] = "ProcessTopic: \"" + @edited_process_topic.description + "\" updated"
      redirect_to process_topics_path
    else
      render 'index'
    end
  end

  def restore
    #restore_process_topics
    @process_topic = ProcessTopic.new
    @process_link = ProcessLink.new
    @keywords = Keyword.find(:all, :order => :description )
    redirect_to process_topics_path
  end

  protected

  def init
    @process_topics = ProcessTopic.find(:all, :order => :description, 
                                        :include => :process_links )
  end

end
