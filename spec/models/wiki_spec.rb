require 'rails_helper'

RSpec.describe Wiki, type: :model do
	let(:my_user) { create(:user) }
	
	it { should belong_to(:user) }
	it { should validate_presence_of(:title) }
	it { should validate_uniqueness_of(:title) }
	it { should validate_presence_of(:user) }
	
	describe "attributes" do
		it "responds to title" do
			my_wiki = Wiki.create(title: "Wiki Title", body: "Wiki body. Same as the title only a little longer", private: false, user: my_user)
			expect(my_wiki).to respond_to(:title)
		end
		
		it "responds to body" do
			my_wiki = Wiki.create(title: "Wiki Title", body: "Wiki body. Same as the title only a little longer", private: false, user: my_user)
			expect(my_wiki).to respond_to(:body)
		end
		
		it "responds to private" do
			my_wiki = Wiki.create(title: "Wiki Title", body: "Wiki body. Same as the title only a little longer", private: false, user: my_user)
			expect(my_wiki).to respond_to(:private)
		end
		
		it "responds to user" do
			my_wiki = Wiki.create(title: "Wiki Title", body: "Wiki body. Same as the title only a little longer", private: false, user: my_user)
			expect(my_wiki).to respond_to(:user)
		end
	end
end
