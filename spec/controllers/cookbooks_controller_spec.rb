require 'rails_helper'

RSpec.describe CookbooksController, type: :controller do
  describe "GET #index" do
    context "logged in user" do
      before :each do
        user = create :user
        session[:user_id] = user.id
        get :index, user_id: user.id
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the index view" do
        expect(response).to render_template(:index)
      end
    end

    context "not logged in user" do
      it "redirects to the home page" do
        get :index, user_id: 2
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    context "logged in user" do
      before :each do
        cookbook = create :cookbook
        user = create :user
        session[:user_id] = user.id
        get :show, user_id: user.id, id: cookbook.id
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the show view" do
        expect(response).to render_template(:show)
      end
    end

    context "not logged in user" do
      before :each do
        user = create :user
        cookbook = create :cookbook
        session[:user_id] = user.id
        # below references a different user
        get :show, user_id: 2, id: cookbook.id
      end

      it "does not respond successfully" do
        expect(response).to_not be_success
      end

      it "redirects to the the logged in user's show page" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #new" do
    context "logged in user" do
      before :each do
        user = create :user
        session[:user_id] = user.id
        get :new, user_id: user.id
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the new view" do
        expect(response).to render_template(:new)
      end
    end

    context "not logged in user" do
      it "does not respond successfully" do
        get :new, user_id: 1
        expect(response).to_not be_success
      end

      it "redirects to the home page" do
        get :new, user_id: 1
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST #create" do
    describe "user not logged in" do
      it "redirects to home page" do
        create :user
        post :create, user_id: 2, cookbook: attributes_for(:cookbook)
        expect(response).to redirect_to(root_path)
      end
    end

    describe "user logged in" do
      context "valid cookbook params" do
        before :each do
          @user = create :user
          session[:user_id]  = @user.id
          session[:previous_url] = user_path(@user.id)

          post :create, user_id: @user.id, cookbook: attributes_for(:cookbook)
        end

        it "creates a cookbook" do
          expect(Cookbook.count).to eq 1
        end

        it "redirects back" do
          expect(response).to redirect_to user_path(@user.id)
        end
      end

      context "invalid cookbook params" do
        before :each do
          @user = create :user
          session[:user_id]  = @user.id
          post :create, user_id: @user.id, cookbook: attributes_for(:cookbook, name: nil)
        end

        it "does not create a cookbook" do
          expect(Cookbook.count).to eq 0
        end

        it "renders the new page" do
          expect(response).to render_template("new", session[:user_id])
        end

        it "flashes error" do
          expect(flash.now[:error]).to include("Could not save. Please check the information and try again.")
        end
      end
    end
  end

  describe "GET #edit" do
    context "logged in user" do
      before :each do
        cookbook = create :cookbook
        user = create :user
        session[:user_id] = user.id
        get :edit, user_id: user.id, id: cookbook.id
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the edit view" do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH #update" do
    describe "user not logged in" do
      it "redirects to cookbook show page" do
        user = create :user
        cookbook = create :cookbook
        put :update, user_id: user.id, id: cookbook.id, :cookbook => { name: "New Name"}
        cookbook.reload

        expect(response).to redirect_to(root_path)
      end
    end

    describe "user logged in" do
      context "valid cookbook params" do
        before :each do
          @user = create :user
          @cookbook = create :cookbook
          session[:user_id]  = @user.id
          put :update, user_id: @user.id, id: @cookbook.id, :cookbook => { name: "New Name"}
          @cookbook.reload
        end

        it "updates the cookbook" do
          expect(Cookbook.all).to include(@cookbook)
          expect(Cookbook.last.name).to eq "New Name"
        end

        it "redirects to the cookbook show page" do
          expect(response).to redirect_to(user_cookbook_path(@user.id, @cookbook.id))
        end
      end

      context "invalid cookbook params" do
        before :each do
          @user = create :user
          @cookbook = create :cookbook
          session[:user_id]  = @user.id
          patch :update, user_id: @user.id, id: @cookbook.id, cookbook: attributes_for(:cookbook, name: nil)
        end

        it "does not update the cookbook" do
          expect(Cookbook.last.name).to eq "Cookies"
        end

        it "redirects to the cookbook show page" do
          expect(response).to redirect_to(user_cookbook_path(@user.id, @cookbook.id))
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @cookbook = create :cookbook
      @user = create :user
      session[:user_id] = @user.id
    end

    it "deletes the record" do
      delete :destroy, user_id: @user.id, id: @cookbook.id

      expect(Cookbook.count).to eq 0
    end

    it "redirects to users#show" do
      delete :destroy,  user_id: @user.id, id: @cookbook.id
      expect(response).to redirect_to user_path(session[:user_id])
    end

    it "does not delete associated recipes or their ingredients" do
      ingredient = create :ingredient
      recipe1 = create :recipe
      recipe2 = create :recipe, name: "Another Recipe"
      @cookbook.recipes << [ recipe1, recipe2 ]

      delete :destroy, user_id: @user.id, id: @cookbook.id
      expect(Recipe.all).to include(recipe1)
      expect(Recipe.all).to include(recipe2)
      expect(Ingredient.all).to include(ingredient)
    end
  end

  describe "PATCH #unassociate" do
    before :each do
      @cookbook = create :cookbook
      create :ingredient
      recipe = create :recipe
      user = create :user
      session[:user_id] = user.id
      @cookbook.recipes << recipe

      patch :unassociate, user_id: user.id, recipe_id: recipe.id, id: @cookbook.id
    end

    it "unassociates a recipe from a cookbook" do
      expect(@cookbook.recipes.count).to eq 0
    end

    it "does not delete the cookbook" do
      expect(Cookbook.count).to eq 1
    end

    it "does not delete the recipe" do
      expect(Recipe.count).to eq 1
    end

    it "does not delete ingredients associated with the recipe" do
      expect(Ingredient.count).to eq 1
    end

    it "redirects to the cookbook show page" do
      expect(response).to redirect_to(user_cookbook_path(session[:user_id], @cookbook.id))
    end
  end
end
