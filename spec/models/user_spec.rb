require 'rails_helper'

RSpec.describe User, type: :model do
	
	it { should have_many(:wikis) }
	
	it { should validate_presence_of(:username) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	it { should allow_value('cameron@james.com').for(:email) }
	it { should_not allow_value('cameronjames.com').for(:email) }
	
  describe "attributes" do
		it "responds to username" do
			my_user = User.create(username: "User", email: "user@example.com", password: "helloworld" )
			expect(my_user).to respond_to(:username)
		end
		
		it "responds to email" do
			my_user = User.create(username: "User", email: "user@example.com", password: "helloworld" )
			expect(my_user).to respond_to(:email)
		end
		
		it "responds to password" do
			my_user = User.create(username: "User", email: "user@example.com", password: "helloworld" )
			expect(my_user).to respond_to(:password)
		end
	end
end
