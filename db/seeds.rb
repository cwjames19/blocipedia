include FactoryGirl::Syntax::Methods
require 'faker'

10.times do
	User.create!(
		username: Faker::Lorem.word,
		email: Faker::Internet.email,
		password: Faker::Lorem.characters(10)
		)
end
User.create(username: 'User', email: 'user@example.com', password: 'helloworld', role: 'standard')
User.create(username: 'Premium', email: 'premium@example.com', password: 'helloworld', role: 'premium')
User.create(username: 'Admin', email: 'admin@example.com', password: 'helloworld', role: 'admin')
users = User.all

40.times do
	Wiki.create!(
		title: Faker::Lorem.characters(6),
		body: Faker::Lorem.paragraph,
		user: User.all.sample
		)
end
wikis = Wiki.all

puts "Seed finished"
puts "#{users.count} users created!"
puts "#{wikis.count} wikis created!"