class Action < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :content
end
