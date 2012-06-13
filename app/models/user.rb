# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation 
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :name,  presence: true
  validates :name, length: { maximum: 50, minimum: 4 }
  # using validates_email_format_of gem
  validates :email, email_format: { message: 'is not valid' },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true 
end

