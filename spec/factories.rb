FactoryGirl.define do
  factory :user do
    name      "Trevor Smith"
    sequence(:email)     { |x| "trevor#{x}@example.com" }
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
  factory :tracker do
    outcome    "pending"
    habit
  end
  factory :reason do
    sequence(:message) { |m| "message#{m}"} 
    user
    habit
  end
  factory :affirmation do
    sequence(:message) { |m| "affirmation message#{m}"} 
    user
    habit
  end

end