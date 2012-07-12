class Step < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :content
end
