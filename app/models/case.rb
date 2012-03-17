class Case < ActiveRecord::Base

  attr_accessor :year, :month, :day, :jurisdiction_id, :pdf

  attr_accessible :claimant, :respondent, :decision_date, 
                  :country_origin, :court_id, :year, :month, :day, 
                  :child_topic_ids, :refugee_topic_ids, :jurisdiction_id, :pdf, :fulltext

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

  # handle child_topics
  validates :child_topic_ids, :presence => true
  has_and_belongs_to_many :child_topics

  # handle refugee_topics
  validates :refugee_topic_ids, :presence => true
  has_and_belongs_to_many :refugee_topics

  # handle uploads
  validate :validate_pdf

  # sphinx index
  define_index do
    indexes [claimant, respondent], :as => :case_name
    indexes court(:name), :as => :court
    indexes child_topics.description, :as => :child_topics
    indexes refugee_topics.description, :as => :refugee_topics
    indexes country_origin
    indexes fulltext
    indexes "TO_CHAR(decision_date, 'YYYY')", :type => :string, :as => :year

    has court_id 
    has "CAST(TO_CHAR(decision_date, 'YYYYMMDD') as INTEGER)", :type => :integer, :as => :decision_date
    has child_topics(:id), :as => :child_topic_ids
    has refugee_topics(:id), :as => :refugee_topic_ids
    has court.jurisdiction(:id), :as => :jurisdiction_id
  end

  private

  # upload pdf
  def validate_pdf
    
    if self.pdf.nil?
      self.errors.add(:pdf, "upload is compulsory")
      return false
    end

    # if editing and no replacement pdf is selected, do not change fulltext
    if self.pdf == ""
      return true
    end

    begin
      directory = "public/pdfs"
      path = File.join(directory, self.pdf.original_filename)
      File.open(path, "wb") do |io|
        io.write(self.pdf.read) 
      end

      # need to open file again for reading after writing
      File.open(path, "rb") do |io|
        reader = PDF::Reader.new(io)
         #self.fulltext = reader.pages.map { |page| page.text }.join(' ') 
        reader.pages.each do |page|
          self.fulltext += page.text 
        end
      end

    rescue PDF::Reader::MalformedPDFError
      self.errors.add(:base, "File selected to upload is not a valid pdf file")
      return false
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
