class Affirmation < ActiveRecord::Base
  attr_accessible :message

  belongs_to :habit
end
# == Schema Information
#
# Table name: affirmations
#
#  id         :integer         not null, primary key
#  message    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  habit_id   :integer
#

