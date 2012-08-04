class CaseSearch < ActiveRecord::Base

  attr_accessor :year_to, :month_to, :day_to, :year_from, :month_from, :day_from

  attr_accessible :free_text, :name, :date_from, :date_to, :day_from, :month_from, 
                  :year_from, :day_to, :month_to, :year_to

  # handle case name
  validates :free_text, :length => { :maximum => 100 }

  # handle dates
  #validate  :validate_dates

  has_and_belongs_to_many :country_origin
  has_and_belongs_to_many :jurisdiction
  has_and_belongs_to_many :court
  has_and_belongs_to_many :child_topics
  has_and_belongs_to_many :refugee_topics
  has_and_belongs_to_many :process_topics
  has_and_belongs_to_many :keywords

  private

  # Validate dates

  #def convert_date
  #  begin
  #    self.decision_date = Date.civil(self.year.to_i, self.month.to_i, 
  #                                    self.day.to_i)
  #  rescue ArgumentError
  #    false
  #  end
  #end

  #def validate_dates
  #  if self.year_to.blank? || self.month.blank? || self.day.blank? 
  #    errors.add(:decision_date, "has not been completed fully")
  #  else
  #  errors.add(:decision_date, "#{self.day}/#{self.month}/#{self.year} is not a valid date.") unless convert_date
  #  end
  #  return errors.blank?
  #end

end
