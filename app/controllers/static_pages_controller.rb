class StaticPagesController < ApplicationController

  def home
    @quotes = Quote.all.shuffle
    @quote1 = @quotes.first
    @quote2 = @quotes.last
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

end
