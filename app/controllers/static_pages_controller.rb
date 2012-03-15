class StaticPagesController < ApplicationController
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

  def about
  end

  def help
  end

  def admin
  end

end
