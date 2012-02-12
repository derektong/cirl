class PagesController < ApplicationController
  def home
    @title = "Home"

    @image_files = %w( .jpg .gif .png )
    @files ||= Dir.entries(
      "app/assets/images/home/bw").delete_if { |x|
        !@image_files.index(x[-4,4])
      }
    @file = @files[rand(@files.length)];
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end
