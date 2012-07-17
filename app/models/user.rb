class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :time_zone 

  has_many :habits, dependent: :destroy

  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name,  presence: true
  validates :name, length: { maximum: 50, minimum: 4 }
  validates :email, presence: true
  # using validates_email_format_of gem
  validates :email, email_format: { message: 'is not valid' },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true 

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end 

