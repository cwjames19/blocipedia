require 'faker'

FactoryGirl.define do
  pw = Faker::Lorem.words(5).join
  factory :user do
    username Faker::Name.first_name
    sequence(:email){|n| "user#{n}@factory.com" }
    password pw
    password_confirmation pw
  end
end
