FactoryGirl.define do
  factory :user do
    name      "Trevor Smith"
    email     "trevor@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end