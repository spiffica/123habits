class Reason < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :importance, :message

  validates :message, presence:true, length: { minimum: 4}
end 
