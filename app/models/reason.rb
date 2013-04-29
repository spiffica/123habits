class Reason < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :importance, :message

  validates :message, presence:true, length: { minimum: 4}
end
# == Schema Information
#
# Table name: reasons
#
#  id         :integer         not null, primary key
#  message    :string(255)
#  importance :integer
#  habit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

