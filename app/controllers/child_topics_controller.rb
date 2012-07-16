class ChildTopicsController < ApplicationController
  include ChildTopicsHelper

  before_filter :init, :only => [:index, :create, :edit, :update, :restore, 
                                 :create_link]

  def index
    @child_topic = ChildTopic.new
    @child_link = ChildLink.new
    @keywords = Keyword.find(:all, :order => :description )
  end

  def edit
    @child_topic = ChildTopic.find(params[:id])
  end

  def create
    @child_topic = ChildTopic.new(params[:child_topic])
    @child_link = ChildLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @child_topic.save
      redirect_to child_topics_path
    else
      render 'index'
    end
  end

  def destroy
    @child_topic = ChildTopic.find(params[:id])
    flash[:success] = "Child topic: \"" + @child_topic.description + "\" deleted"
    @child_topic.destroy
    redirect_to child_topics_path
  end

  def update
    @edited_child_topic = ChildTopic.find(params[:id])
    @child_topic = ChildTopic.new
    @child_link = ChildLink.new
    @keywords = Keyword.find(:all, :order => :description )
    if @edited_child_topic.update_attributes(params[:child_topic])
      flash[:success] = "ChildTopic: \"" + @edited_child_topic.description + "\" updated"
      redirect_to child_topics_path
    else
      render 'index'
    end
  end

  def restore
    restore_child_topics
    @child_topic = ChildTopic.new
    @child_link = ChildLink.new
    @keywords = Keyword.find(:all, :order => :description )
    redirect_to child_topics_path
  end

  protected

  def init
    @child_topics = ChildTopic.find(:all, :order => :description, 
                                    :include => :child_links )
  end

end
