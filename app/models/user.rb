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

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
