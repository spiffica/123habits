FactoryGirl.define do
  factory :user do
    name      "Trevor Smith"
    email     "trevor@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
  factory :habit do
  	sequence(:statement) { |s| "I will stop #{s}"} 
  	user	
  	habit_type	"kick"
  	trait :starting do
  		habit_type 	"start"
  	end
  end
  factory :reason do
  	sequence(:message) { |m| "message#{m}"}	
  	user
  	habit
  end

end