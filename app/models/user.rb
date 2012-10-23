class User < ActiveRecord::Base
  include UserTime
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


  def self.midnight
    self.all.find_all do |u|
      u.is_midnight?
    end
  end


  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end 

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  time_zone       :string(255)     default("Pacific Time (US & Canada)")
#

