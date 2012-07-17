class Step < ActiveRecord::Base
  belongs_to :habit
  attr_accessible :content

  validates :content, length: { minimum: 4 }
end
