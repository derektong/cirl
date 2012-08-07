class AdminController < ApplicationController
  include CourtsHelper
  include QuotesHelper
  include CountryOriginsHelper
  include KeywordsHelper
  include RefugeeTopicsHelper
  include ChildTopicsHelper
  include ProcessTopicsHelper

  before_filter :signed_in_user
  before_filter :admin_user, only: [:admin]
  before_filter :managing_admin_user, only: [:reset_database, :restore_courts, :restore_quotes,
                                             :restore_country_origins, :restore_keywords]

  def index
  end

  def reset_database
  end

  def restore_courts
    restore_courts
    @court = Court.new
    redirect_to admin_reset_database_path
  end

  def restore_keywords
    restore_keywords
    restore_refugee_topics
    restore_child_topics
    restore_process_topics
    @keyword = Keyword.new
    redirect_to admin_reset_database_path
  end

  def restore_country_origins
    restore_country_origins
    @country_origin = CountryOrigin.new
    redirect_to admin_reset_database_path
  end

  def restore_quotes
    restore_quotes
    redirect_to quotes_path
  end
end
