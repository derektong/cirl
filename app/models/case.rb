class Case < ActiveRecord::Base

  attr_accessor :year, :month, :day, :jurisdiction_id, :pdf

  attr_accessible :claimant, :respondent, :decision_date, 
                  :country_origin, :court_id, :year, :month, :day, 
                  :subject_ids, :issue_ids, :jurisdiction_id, :pdf, :fulltext

  # handle case name
  validates :claimant,  :presence => true,
                        :length => { :maximum => 100 }
  validates :respondent,  :presence => true,
                          :length => { :maximum => 100 }

  # handle dates
  validates :year, :presence => true
  validates :month, :presence => true
  validates :day, :presence => true
  validate  :validate_decision_date

  validates :country_origin, :presence => true
  validates :jurisdiction_id, :presence => true

  # handle courts
  validates :court_id, :presence => true
  belongs_to :court

  # handle subjects
  validates :subject_ids, :presence => true
  has_and_belongs_to_many :subjects

  # handle issues
  validates :issue_ids, :presence => true
  has_and_belongs_to_many :issues

  # handle uploads
  validate  :validate_pdf

  # sphinx index
  define_index do
    indexes [claimant, respondent], :as => :case_name
    indexes court(:name), :as => :court
    indexes subjects.description, :as => :subjects
    indexes issues.description, :as => :issues
    indexes country_origin
    indexes fulltext

    has court_id
    has subjects(:id), :as => :subject_ids
    has issues(:id), :as => :issue_ids
    has court.jurisdiction(:id), :as => :jurisdiction_id
  end

  private

  # upload pdf
  def validate_pdf

    #skip pdfing for the moment
    return

    directory = "public/pdfs"
    path = File.join(directory, self.id, ".pdf")
    File.open(path, "wb") do |io|
      io.write(self.pdf.read) 
    end

    # need to open file again for reading after writing
    File.open(path, "rb") do |io|
      reader = PDF::Reader.new(io)
      # consider how to handle really large files
       self.fulltext = reader.page(1).text
       #logger.info reader.pages.map { |page| page.text }.join(' ') 
    end
  end


  # Validate dates

  def convert_date
    begin
      self.decision_date = Date.civil(self.year.to_i, self.month.to_i, 
                                      self.day.to_i)
    rescue ArgumentError
      false
    end
  end

  def validate_decision_date
    if self.year.blank? || self.month.blank? || self.day.blank? 
      errors.add(:decision_date, "has not been completed fully")
    else
    errors.add(:decision_date, "#{self.day}/#{self.month}/#{self.year} is not a valid date.") unless convert_date
    end
    return errors.blank?
  end
end
