class CaseSearch < ActiveRecord::Base

  attr_accessor :year_to, :month_to, :day_to, :year_from, :month_from, :day_from

  attr_accessible :free_text, :name, :date_from, :date_to, :day_from, :month_from, 
                  :year_from, :day_to, :month_to, :year_to, :case_name, :country_origin_ids, 
                  :jurisdiction_ids, :court_ids, :process_topic_ids, :child_topic_ids, 
                  :refugee_topic_ids, :keyword_ids

  # handle case name
  validates :free_text, :length => { :maximum => 100 }

  # handle dates

  has_and_belongs_to_many :country_origins
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :courts
  has_and_belongs_to_many :child_topics
  has_and_belongs_to_many :refugee_topics
  has_and_belongs_to_many :process_topics
  has_and_belongs_to_many :keywords

  belongs_to :user

  def description
   description = [] 
   description << "for \"" + self.free_text + "\" in all fields" if 
    !self.free_text.empty? 
   description << "for a case name containing: \"" + self.case_name + "\"" if 
    !self.case_name.empty? 
   description << "for a case decided between " + self.date_from.strftime("%d %b %Y") + 
                  " and " + self.date_to.strftime("%d %b %Y") if self.date_from && self.date_to 
   description << "where the applicant was from: \"" + 
                  self.country_origins.map(&:name).join(' or ') + "\"" if 
                  !self.country_origins.empty? 
   description << "decided in: \"" + self.jurisdictions.map(&:name).join(' or ') + "\"" if 
                  !self.jurisdictions.empty? 
   description << "in the: \"" + self.courts.map(&:name).join(' or ') + "\"" if 
                  !self.courts.empty? 
   description << "with the following process/procedure concepts: \"" + 
                  self.process_topics.map(&:description).join(' or ') + "\"" if 
                  !self.process_topics.empty? 
   description << "with the following children's rights concepts: \"" + 
                  self.child_topics.map(&:description).join(' or ') + "\"" if 
                  !self.child_topics.empty? 
   description << "with the following refugee rights concepts: \"" + 
                  self.refugee_topics.map(&:description).join(' or ') + "\"" if 
                  !self.refugee_topics.empty? 

   keyword_descriptions = []
   current_description = ""
   self.keywords.each do |keyword|
     current_description = keyword.description
     if !keyword.aliases.empty?
       keyword.aliases.each do |a|
         current_description += "/" + a.description
       end
     end
     keyword_descriptions << current_description
   end

   description << "with the following keywords: \"" + keyword_descriptions.join(' or ') + "\"" if !self.keywords.empty? 
   return description.join(', ')
  end

  def validate_dates
    # ok to leave all blank
    if self.year_to.blank? && self.month_to.blank? && self.day_to.blank? &&
       self.year_from.blank? && self.month_from.blank? && self.day_from.blank?
      return true 
    end

    # otherwise need to fill them all in
    if self.year_to.blank? || self.month_to.blank? || self.day_to.blank? 
      errors.add(:date_to, "has not been completed fully")
    else
      errors.add(:date_to, "#{self.day_to}/#{self.month_to}/#{self.year_to} is not a valid date.") unless convert_date_to
    end

    if self.year_from.blank? || self.month_from.blank? || self.day_from.blank?
      errors.add(:date_from, "has not been completed fully")
    else
      errors.add(:date_from, "#{self.day_from}/#{self.month_from}/#{self.year_from} is not a valid date.") unless convert_date_from
    end

    # date to needs to be greater than date from
    if errors.blank?
      errors.add(:base, "Date to needs to be after date from") unless self.date_from < self.date_to
    end

    if errors.blank?
      self.save
    end

    return errors.blank?
  end

  private

  # Validate dates

  def convert_date_to
    begin
      self.date_to = Date.civil(self.year_to.to_i, self.month_to.to_i, 
                                self.day_to.to_i)
    rescue ArgumentError
      false
    end
  end

  def convert_date_from
    begin
      self.date_from = Date.civil(self.year_from.to_i, self.month_from.to_i, 
                                  self.day_from.to_i)
    rescue ArgumentError
      false
    end
  end

end
