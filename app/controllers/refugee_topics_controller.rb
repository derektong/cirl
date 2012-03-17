class RefugeeTopicsController < ApplicationController
  def index
    @refugee_topics = RefugeeTopic.find(:all, :order => :description )
    @refugee_topic = RefugeeTopic.new
  end

  def create
    @refugee_topics = RefugeeTopic.find(:all, :order => :description )
    @refugee_topic = RefugeeTopic.new(params[:refugee_topic])
    if @refugee_topic.save
      redirect_to refugee_topics_path
    else
      render 'index'
    end
  end

  def destroy
    RefugeeTopic.find(params[:id]).destroy
    flash[:success] = "Legal refugee_topic removed."
    redirect_to refugee_topics_path
    respond_to do |format|
      format.html { redirect_to refugee_topics_path }
      format.js { render :js => "window.location = '" + refugee_topics_path + "'" }
    end
  end

  def update
    @refugee_topics = RefugeeTopic.find(:all, :order => :description )
    @edited_refugee_topic = RefugeeTopic.find(params[:id])
    @refugee_topic = RefugeeTopic.new
    if @edited_refugee_topic.update_attributes(:description => params[:update_value])
      redirect_to refugee_topics_path
    else
      render 'index'
    end
  end

end
