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
  attr_accessible :email, :name

  validates :name,  presence: true
  validates :name, length: { maximum: 50, minimum: 4 }
  # using validates_email_format_of gem
  validates :email, email_format: { message: 'is not valid' },
            uniqueness: { case_sensitive: false }
end

