require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
	describe "#home" do
		it "returns http status, success" do
			get :home
			expect(response).to have_http_status(:success)
		end
		
		it "displays the home page" do
			get :home
			expect(response).to render_template(:home)
		end
	end
end
