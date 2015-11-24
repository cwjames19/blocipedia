require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_wiki) { create(:wiki, user: my_user) }
  
  context "guest" do
    describe "GET #new" do
      it "redirects the user to the sign-in page" do
        get :new, user_id: my_user
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    describe "POST #create" do
      it "redirects the user to the sign-in page" do
        post :create, user: my_user
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    describe "GET #show" do
      it "returns http success" do
        get :show, id: my_wiki
        expect(response).to have_http_status(:success)
      end
    end
    
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  
    describe "DELETE #destroy" do
      it "redirects the user to the sign-in page" do
        delete :destroy, id: my_wiki
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    describe "GET #edit" do
      it "redirects the user to the sign-in page" do
        get :edit, id: my_wiki
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    describe "PUT #update" do
      it "redirects the user to the sign-in page" do
        get :update, id: my_wiki
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  
  context "user" do
    before { sign_in my_user }
    describe "GET #new" do
      it "returns http success" do
        get :new, user_id: my_user
        expect(response).to have_http_status(:success)
      end
      
      it "renders the show view" do
        get :new, user_id: my_user
        expect(response).to render_template(:new)
      end
      
      it "instantiates @wiki" do
        get :new, user: my_user
        expect(assigns(:wiki)).not_to be_nil
      end
    end
    
    describe "POST #create" do
      it "increases the number of wikis by one" do
        pre_count = Wiki.all.count
        post :create, user_id: my_user, wiki: { title: "Moose", body: "Big horns", private: false }
        expect(Wiki.all.count).to eq(pre_count + 1)
      end
      
      it "assigns @wiki to the newly created wiki" do
        post :create, user_id: my_user, wiki: { title: "Moose", body: "Big horns", private: false }
        expect(assigns(:wiki)).to eq(Wiki.last)
      end
      
      it "assigns the user input to the new wiki's attributes" do
        my_title = "Aardvark"
        my_body = "An animal that I know next to nothing about"
        my_boolean = true
        post :create, user_id: my_user, wiki: { title: my_title, body: my_body, private: my_boolean }
        this_wiki = Wiki.all.last
        expect(this_wiki.title).to eq my_title
        expect(this_wiki.body).to eq my_body
        expect(this_wiki.private).to eq my_boolean
      end
    end
    
    describe "GET #show" do
      it "returns http status, success" do
        get :show, id: my_wiki
        expect(response).to have_http_status :success
      end
      
      it "renders the show view" do
        get :show, id: my_wiki
        expect(response).to render_template :show
      end
      
      it "assigns my_wiki to @wiki" do
        get :show, id: my_wiki
        expect(assigns(:wiki)).to eq my_wiki
      end
    end
    
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    
    describe "DELETE destroy" do
      it "redirects to the wiki index page" do
        delete :destroy, id: my_wiki
        expect(response).to redirect_to wikis_path
      end
      
      it "decreases the number of wiki by one" do
        this_wiki = create(:wiki, user: my_user)
        pre_count = Wiki.all.count
        delete :destroy, id: this_wiki
        expect(Wiki.all.count).to eq(pre_count - 1)
      end
      
      it "deletes my_wiki" do
        this_wiki = create(:wiki, user: my_user)
        delete :destroy, id: this_wiki
        count = Wiki.where(id: this_wiki).size
        expect(count).to eq 0
      end
    end
    
    describe "GET #EDIT" do
      it "returns http success" do
        get :edit, id: my_wiki
        expect(response).to have_http_status :success
      end
      
      it "renders the edit view" do
        get :edit, id: my_wiki
        expect(response).to render_template :edit
      end
      
      it "assigns my_wiki to @wiki" do
        get :edit, id: my_wiki
        expect(assigns(:wiki)).to eq my_wiki
      end
    end
    
    describe "PUT #update" do
      it "updates wiki with expected attributes" do
        new_title = "Zebras..."
        new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"
        new_boolean = false
        
        put :update, id: my_wiki, wiki: {title: new_title, body: new_body, private: new_boolean }
        
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.title).to eq new_title
        expect(updated_wiki.body).to eq new_body
        expect(updated_wiki.private).to eq new_boolean
      end
      
      it "redirects to the updated wiki's page" do
        new_title = "Zebras..."
        new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"
        new_boolean = "false"
        
        put :update, id: my_wiki, wiki: {title: new_title, body: new_boolean, private: new_boolean }
        expect(response).to redirect_to [:wiki]
      end
    end
  end
end
