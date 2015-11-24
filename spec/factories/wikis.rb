require 'faker'

FactoryGirl.define do
	factory :wiki do
		title Faker::Hacker.verb
		body Faker::Hacker.say_something_smart
		private false
		user nil
	end

end
