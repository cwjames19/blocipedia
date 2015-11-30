require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
	describe "#index" do
		it "returns http status, success" do
			get :index
			expect(response).to have_http_status(:success)
		end
		
		it "displays the home page" do
			get :index
			expect(response).to render_template(:index)
		end
	end
end
