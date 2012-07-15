class RefugeeTopicsController < ApplicationController
  include RefugeeTopicsHelper

  before_filter :init, :only => [:index, :create, :edit, :update, :restore, 
                                 :create_link]

  def index
    @refugee_topic = RefugeeTopic.new
    @refugee_link = RefugeeLink.new
    @keywords = Keyword.find(:all, :order => :description )
  end

  def edit
    @refugee_topic = RefugeeTopic.find(params[:id])
  end

  def create
    @refugee_topic = RefugeeTopic.new(params[:refugee_topic])
    @refugee_link = RefugeeLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @refugee_topic.save
      redirect_to refugee_topics_path
    else
      render 'index'
    end
  end

  def destroy
    @refugee_topic = RefugeeTopic.find(params[:id])
    flash[:success] = "Refugee topic: \"" + @refugee_topic.description + "\" deleted"
    @refugee_topic.destroy
    redirect_to refugee_topics_path
  end

  def update
    @edited_refugee_topic = RefugeeTopic.find(params[:id])
    @refugee_topic = RefugeeTopic.new
    @refugee_link = RefugeeLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @edited_refugee_topic.update_attributes(params[:refugee_topic])
      flash[:success] = "RefugeeTopic: \"" + @edited_refugee_topic.description + "\" updated"
      redirect_to refugee_topics_path
    else
      render 'index'
    end
  end

  def restore
    restore_refugee_topics
    @refugee_topic = RefugeeTopic.new
    @refugee_link = RefugeeLink.new
    @keywords = Keyword.find(:all, :order => :description )
    redirect_to refugee_topics_path
  end

  protected

  def init
    @refugee_topics = RefugeeTopic.find(:all, :order => :description, 
                                        :include => :refugee_links )
  end

end
