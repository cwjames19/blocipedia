require 'rails_helper'
require 'faker'

RSpec.describe WikisController, type: :controller do
  let(:my_user) { create(:user) }
  let(:my_wiki) { create(:wiki, user: my_user) }
  let(:other_user) { create(:user) }
  let(:other_wiki) { create(:wiki, user: other_user) }
  let(:premium_user) { create(:user, role: 'premium') }
  let(:private_wiki) { create(:wiki, user: premium_user, private: true) }
  let(:admin) { create(:user, role: 'admin') }
  
  context "unsigned-in guest" do
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
  
  
  context "standard user" do
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
        post :create, user_id: my_user, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(Wiki.all.count).to eq(pre_count + 1)
      end
      
      it "assigns @wiki to the newly created wiki" do
        post :create, user_id: my_user, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(assigns(:wiki)).to eq(Wiki.last)
      end
      
      it "assigns the user input to the new wiki's attributes" do
        my_title = Faker::Lorem.word
        my_body = Faker::Lorem.words(6).join
        post :create, user_id: my_user, wiki: { title: my_title, body: my_body}
        this_wiki = Wiki.all.last
        expect(this_wiki.title).to eq my_title
        expect(this_wiki.body).to eq my_body
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
      
      it "redirects to the home page for private topics" do
        get :show, id: private_wiki
        expect(response).to redirect_to root_path
      end
    end
    
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end
    end
    
    describe "DELETE destroy" do
      context "wiki owned by the user" do
        it "redirects to the wiki index page" do
          delete :destroy, id: my_wiki
          expect(response).to redirect_to wikis_path
        end
        
        it "decreases the number of wiki by one" do
          my_wiki
          pre_count = Wiki.all.count
          delete :destroy, id: my_wiki
          expect(Wiki.all.count).to eq(pre_count - 1)
        end
        
        it "deletes my_wiki" do
          delete :destroy, id: my_wiki
          count = Wiki.where(id: my_wiki).size
          expect(count).to eq 0
        end
      end
      
      context "wiki not owned by user" do
        it "does not delete wikis the user does not own" do
          delete :destroy, id: private_wiki
          count = Wiki.where(id: private_wiki).size
          expect(count).to eq 1
        end
        
        it "redirects to the home page" do
          delete :destroy, id: private_wiki
          expect(response).to redirect_to root_path
        end
      end
    end
    
    describe "GET #EDIT" do
      it "returns http success for a wiki owned by the user" do
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
      
      it "returns http success for a public wiki owned by another user" do
        get :edit, id: other_wiki
        expect(response).to have_http_status :success
      end
    end
    
    describe "PUT #update" do
      context "public wiki" do
        it "updates own wiki with expected attributes" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"
          new_boolean = false
          
          put :update, id: my_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end
        
        it "redirects to the updated wiki's page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"
          new_boolean = "false"
          
          put :update, id: my_wiki, wiki: {title: new_title, body: new_boolean}
          expect(response).to redirect_to [:wiki]
        end
        
        it "updates a public wiki made by someone else with expected attributes" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"
          new_boolean = false
          
          put :update, id: other_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end
      end
      
      context "private wiki" do
        it "does not alter private wiki's attributes" do
          original_wiki = private_wiki
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: private_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq original_wiki.title
          expect(updated_wiki.body).to eq original_wiki.body
        end
        
        it "redirects user to home page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: private_wiki, wiki: {title: new_title, body: new_body}
          expect(response).to redirect_to root_path
        end
      end
    end
  end
  
  
  context "premium user" do
    before { sign_in premium_user }
    describe "GET #new" do
      it "returns http success" do
        get :new, user_id: premium_user
        expect(response).to have_http_status(:success)
      end
      
      it "renders the show view" do
        get :new, user_id: premium_user
        expect(response).to render_template(:new)
      end
      
      it "instantiates @wiki" do
        get :new, user: premium_user
        expect(assigns(:wiki)).not_to be_nil
      end
    end
    
    describe "POST #create" do
      it "increases the number of wikis by one" do
        pre_count = Wiki.all.count
        post :create, user_id: premium_user, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(Wiki.all.count).to eq(pre_count + 1)
      end
      
      it "assigns @wiki to the newly created wiki" do
        post :create, user_id: premium_user, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(assigns(:wiki)).to eq(Wiki.last)
      end
      
      it "assigns the user input to the new wiki's attributes" do
        my_title = Faker::Lorem.word
        my_body = Faker::Lorem.words(6).join
        post :create, user_id: premium_user, wiki: { title: my_title, body: my_body}
        this_wiki = Wiki.all.last
        expect(this_wiki.title).to eq my_title
        expect(this_wiki.body).to eq my_body
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
      
      it "returns http status, success, for private topics" do
        get :show, id: private_wiki
        expect(response).to have_http_status :success
      end
    end
    
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      
      it "renders the index view" do
        get :index
        expect(response).to render_template :index
      end
    end
    
    describe "DELETE destroy" do
      context "wiki owned by the user" do
        it "redirects to the wiki index page" do
          delete :destroy, id: private_wiki
          expect(response).to redirect_to wikis_path
        end
        
        it "decreases the number of wiki by one" do
          private_wiki
          pre_count = Wiki.all.count
          delete :destroy, id: private_wiki
          expect(Wiki.all.count).to eq(pre_count - 1)
        end
        
        it "deletes my_wiki" do
          delete :destroy, id: private_wiki
          count = Wiki.where(id: private_wiki).size
          expect(count).to eq 0
        end
      end
      
      context "wiki not owned by user" do
        it "does not delete wikis the user does not own" do
          delete :destroy, id: my_wiki
          count = Wiki.where(id: my_wiki).size
          expect(count).to eq 1
        end
        
        it "redirects to the home page" do
          delete :destroy, id: my_wiki
          expect(response).to redirect_to root_path
        end
      end
    end
    
    describe "GET #EDIT" do
      it "returns http success for public wikis" do
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
      
      it "returns http success for a private wiki owned by the user" do
        get :edit, id: private_wiki
        expect(response).to have_http_status :success
      end
      
      #it "returns ?????????? for a private wiki which the user does not own" do
      #  get :edit, id: other_wiki
      #  expect(response).to have_http_status :success
      #end
      
      #it "returns http success for a private wiki which the user does not own but for which they are a collaborator" do
      #  get :edit, id: other_wiki
      #  expect(response).to have_http_status :success
      #end
    end
    
    describe "PUT #update" do
      context "public wiki" do
        it "updates public wiki made by another user with expected attributes" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: my_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end
        
        it "redirects to the updated wiki's page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: my_wiki, wiki: {title: new_title, body: new_body}
          expect(response).to redirect_to [:wiki]
        end
      end
      
      context "private wiki for which the user is a creator" do
        it "updates wiki with the correct attributes" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: my_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end
        
        it "redirects user to home page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: private_wiki, wiki: {title: new_title, body: new_body}
          expect(response).to redirect_to [:wiki]
        end
      end
      
      context "private wiki for which the user is a collaborator" do
        before {
          new_private_wiki = Wiki.create!( user: admin, title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: true )
          new_private_wiki.collaborators.build(wiki_id: new_private_wiki.id, user_id: premium_user.id, user_email: premium_user.email)
        }
        it "updates wiki with the correct attributes" do
          #new_private_wiki = Wiki.create!( user: admin, title: 'joobs', body: Faker::Lorem.words(6).join, private: true )
          new_private_wiki = Wiki.find(1)
          new_private_wiki.collaborators.build(wiki_id: new_private_wiki.id, user_id: premium_user.id, user_email: premium_user.email)
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: new_private_wiki, wiki: { title: new_title, body: new_body }

          updated_wiki = assigns(:wiki)
          expect(updated_wiki).to eq new_private_wiki
          expect(updated_wiki.title).to eq new_title
          expect(updated_wiki.body).to eq new_body
        end
        
        it "redirects user to home page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: private_wiki, wiki: {title: new_title, body: new_body}
          expect(response).to redirect_to [:wiki]
        end
      end
      
      context "private wiki for which the user is not a collaborator" do
        before { new_private_wiki = Wiki.create( user_id: admin, title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: true ) }
        it "does not alter private wiki's attributes" do
          original_wiki = new_private_wiki
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: new_private_wiki, wiki: {title: new_title, body: new_body}
          
          updated_wiki = assigns(:wiki)
          expect(updated_wiki.title).to eq original_wiki.title
          expect(updated_wiki.body).to eq original_wiki.body
        end
        
        it "redirects user to home page" do
          new_title = "Zebras..."
          new_body = "... are what happen when you try to fill in a drawing of a horse with an Etch-A-Sketch"

          put :update, id: private_wiki, wiki: {title: new_title, body: new_body}
          expect(response).to redirect_to root_path
        end
      end
    end
  end
  
  
  context "admin user" do
    before { sign_in admin }
    describe "GET #new" do
      it "returns http success" do
        get :new, user_id: admin
        expect(response).to have_http_status(:success)
      end
      
      it "renders the show view" do
        get :new, user_id: admin
        expect(response).to render_template(:new)
      end
      
      it "instantiates @wiki" do
        get :new, user: admin
        expect(assigns(:wiki)).not_to be_nil
      end
    end
    
    describe "POST #create" do
      it "increases the number of wikis by one" do
        pre_count = Wiki.all.count
        post :create, user_id: admin, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(Wiki.all.count).to eq(pre_count + 1)
      end
      
      it "assigns @wiki to the newly created wiki" do
        post :create, user_id: admin, wiki: { title: Faker::Lorem.word, body: Faker::Lorem.words(6).join, private: false }
        expect(assigns(:wiki)).to eq(Wiki.last)
      end
      
      it "assigns the user input to the new wiki's attributes" do
        my_title = Faker::Lorem.word
        my_body = Faker::Lorem.words(6).join
        my_boolean = true
        post :create, user_id: admin, wiki: { title: my_title, body: my_body, private: my_boolean }
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
