class QuotesController < ApplicationController
  before_filter :signed_in_user
  before_filter :managing_admin_user

  def index
    @quotes = Quote.find(:all, :order => "LOWER(description)" )
    @quote = Quote.new
  end

  def create
    @quote = Quote.new(params[:quote])
    if @quote.save
      redirect_to quotes_path
    else
      render 'index'
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    flash[:success] = "Quote: \"" + @quote.description + "\" deleted"
    @quote.destroy
    redirect_to quotes_path
  end

end
