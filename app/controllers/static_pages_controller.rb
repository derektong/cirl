class StaticPagesController < ApplicationController
  before_filter :signed_in_user, only: [:admin, :reset_database]
  before_filter :admin_user, only: [:admin]
  before_filter :managing_admin_user, only: [:reset_database]


  def home
    @image_files = %w( .jpg .gif .png )
    @files ||= Dir.entries(
      "app/assets/images/home/bw").delete_if { |x|
        !@image_files.index(x[-4,4])
      }
    @file = @files[rand(@files.length)];
  end

  def contact
  end

  def about_cirl
  end

  def about_diana
  end

  def about_advisory
  end

  def help
  end

  def admin
  end

  def reset_database
  end

end
