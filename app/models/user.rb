class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true,
                    length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX } 
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_and_belongs_to_many :cases
  has_and_belongs_to_many :legal_resources
  has_and_belongs_to_many :legal_briefs
  has_many :uploaded_briefs, :class_name => "LegalBrief"
  has_and_belongs_to_many :legal_resources
  has_many :case_searches
  has_many :legal_resource_searches

  def managing_admin?
    return self.user_type === 2
  end

  def admin?
    return self.user_type > 0
  end

  def toggle_admin
    if self.user_type == 0
      return self.update_attribute(:user_type, 1 )
    else
      return self.update_attribute(:user_type, 0 )
    end
  end

  def save_case( new_case )
    if self.cases.exists?( new_case.id )
      return false
    else
      self.cases << new_case
      return true
    end
  end

  def unsave_case( old_case )
    if self.cases.delete( old_case )
      return true
    else
      return false
    end
  end

  def save_legal_brief( new_legal_brief )
    if self.legal_briefs.exists?( new_legal_brief.id )
      return false
    else
      self.legal_briefs << new_legal_brief
      return true
    end
  end

  def unsave_legal_brief( old_legal_brief )
    if self.legal_briefs.delete( old_legal_brief )
      return true
    else
      return false
    end
  end

  def save_legal_resource( new_legal_resource )
    if self.legal_resources.exists?( new_legal_resource.id )
      return false
    else
      self.legal_resources << new_legal_resource
      return true
    end
  end

  def unsave_legal_resource( old_legal_resource )
    if self.legal_resources.delete( old_legal_resource )
      return true
    else
      return false
    end
  end

  def save_case_search( new_case_search )
    if self.case_searches.exists?( new_case_search.id )
      return false
    else
      self.case_searches << new_case_search
      recent_searches = self.case_searches.find_all_by_name( nil, :order => "created_at" )
      if recent_searches.size > 5
        self.case_searches.delete( recent_searches.first )
      end
      return true
    end
  end

  def unsave_case_search( old_case_search )
    if self.case_searches.delete( old_case_search )
      return true
    else
      return false
    end
  end


  def save_legal_resource_search( new_legal_resource_search )
    if self.legal_resource_searches.exists?( new_legal_resource_search.id )
      return false
    else
      self.legal_resource_searches << new_legal_resource_search
      recent_searches = self.legal_resource_searches.find_all_by_name( nil, :order => "created_at" )
      if recent_searches.size > 5
        self.legal_resource_searches.delete( recent_searches.first )
      end
      return true
    end
  end

  def unsave_legal_resource_search( old_legal_resource_search )
    if self.legal_resource_searches.delete( old_legal_resource_search )
      return true
    else
      return false
    end
  end

  private
  
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
