class Affirmation < ActiveRecord::Base
  attr_accessible :message

  belongs_to :habit
end
