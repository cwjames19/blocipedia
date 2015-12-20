require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
	let(:my_user) { create(:user, role: 'premium') }
	let(:private_wiki) { create(:wiki, user: my_user) }
	let(:other_user) { create(:user, email: 'other@example.com',  role: 'premium') }
	let(:other_user_2) { create(:user, email: 'other2@example.com',  role: 'premium') }
	let(:other_user_3) { create(:user, email: 'other3@example.com',  role: 'premium') }
	
	describe "#new" do
		
	end
	
	describe "#create" do
		it "redirects to the wiki's #show page" do
			post :create, { wiki_id: private_wiki.id, user_email: 'other@example.com' }
			expect(response).to redirect_to private_wiki
		end
		
		it "creates a collaborator" do
			pre_count = private_wiki.collaborators.count
			post :create, { wiki_id: private_wiki.id, user_email: other_user.email }
			expect(private_wiki.collaborators.count).to eq(pre_count + 1)
		end
		
		it "adds the correct user as a collaborator" do
			post :create, { wiki_id: private_wiki.id, user_email: other_user.email }
			expect(private_wiki.collaborators.last.user_id).to eq other_user.id
		end
	end
	
	describe "#destroy" do
		before { 
			other_user
			post :create, { wiki_id: private_wiki.id, user_email: other_user.email }
		}
		it "decreases the number of collaborators by one" do
			other_user
			pre_count = private_wiki.collaborators.count
			delete :destroy, { wiki_id: private_wiki.id, id: other_user }
			expect(private_wiki.collaborators.count).to eq(pre_count - 1)
		end
		
		it "deletes the collaborator" do
			other_user
			delete :destroy, { wiki_id: private_wiki.id, id: other_user }
			expect(private_wiki.collaborators.where(user_id: other_user.id).first).to be_nil
		end
	end
end