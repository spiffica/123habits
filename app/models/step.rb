class Step < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :content

  validates :content, length: { minimum: 4 }
end
# == Schema Information
#
# Table name: steps
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

