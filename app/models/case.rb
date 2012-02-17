class Case < ActiveRecord::Base

  attr_accessor :year, :month, :day, :jurisdiction_id

  attr_accessible :claimant, :respondent, :decision_date, 
                  :country_origin, :court_id, :year, :month, :day, 
                  :subject_ids, :issue_ids, :jurisdiction_id

  validates :claimant,  :presence => true,
                        :length => { :maximum => 100 }

  validates :respondent,  :presence => true,
                          :length => { :maximum => 100 }

  validates :year, :presence => true
  validates :month, :presence => true
  validates :day, :presence => true
  validate  :validate_decision_date

  validates :country_origin, :presence => true

  validates :jurisdiction_id, :presence => true

  validates :court_id, :presence => true

  validates :subject_ids, :presence => true

  validates :issue_ids, :presence => true

  belongs_to :court
  has_and_belongs_to_many :subjects
  has_and_belongs_to_many :issues

  private

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
    errors.add("#{self.day}/#{self.month}/#{self.year}", 
               "is an invalid decision date.") unless convert_date
  end


end
