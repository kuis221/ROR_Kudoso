require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TodosController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Todo. As you add validations to Todo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
        name: 'Todo',
        description: 'Todo description',
        required: true,
        kudos: 10,
        active: true
    }
  }

  let(:invalid_attributes) {
    {
        name: nil
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FamilyActivitiesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context 'as a parent' do
    before(:each) do
      @user = FactoryGirl.create(:user, admin: false)
      @family = @user.member.family
      sign_in(@user)
    end

    describe "GET index" do
      it "assigns all todos as @todos" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :index, {family_id: @family.id}, valid_session
        expect(assigns(:todos)).to match_array(@family.todos)
      end
    end

    describe "GET show" do
      it "assigns the requested todo as @todo" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :show, {family_id: @family.id, :id => todo.to_param}, valid_session
        expect(assigns(:todo)).to eq(todo)
      end
    end

    describe "GET new" do
      it "assigns a new todo as @todo" do
        get :new, {family_id: @family.id}, valid_session
        expect(assigns(:todo)).to be_a_new(Todo)
      end
    end

    describe "GET edit" do
      it "assigns the requested todo as @todo" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :edit, {family_id: @family.id, :id => todo.to_param}, valid_session
        expect(assigns(:todo)).to eq(todo)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Todo" do
          expect {
            post :create, {family_id: @family.id, :todo => valid_attributes}, valid_session
          }.to change(Todo, :count).by(1)
        end

        it "assigns a newly created todo as @todo" do
          post :create, {family_id: @family.id, :todo => valid_attributes}, valid_session
          expect(assigns(:todo)).to be_a(Todo)
          expect(assigns(:todo)).to be_persisted
        end

        it "redirects to the created todo" do
          post :create, {family_id: @family.id, :todo => valid_attributes}, valid_session
          expect(response).to redirect_to(@family)
        end


        it "acceptes a todo_template and creates the todo" do
          todo_template = FactoryGirl.create(:todo_template)
          expect {
            post :create, {family_id: @family.id, :todo_template_id => todo_template.id}, valid_session
          }.to change(Todo, :count).by(1)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved todo as @todo" do
          post :create, {family_id: @family.id, :todo => invalid_attributes}, valid_session
          expect(assigns(:todo)).to be_a_new(Todo)
        end

        it "re-renders the 'new' template" do
          post :create, {family_id: @family.id, :todo => invalid_attributes}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          {
              name: 'New Todo',
              description: 'Another description',
              required: false,
              kudos: 30,
          }
        }

        it "updates the requested todo" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => new_attributes}, valid_session
          todo.reload
          expect(todo.name).to eq('New Todo')
          expect(todo.description).to eq('Another description')
          expect(todo.required).to be_falsey
          expect(todo.kudos).to eq(30)
        end

        it "assigns the requested todo as @todo" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => valid_attributes}, valid_session
          expect(assigns(:todo)).to eq(todo)
        end

        it "redirects to the todo" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => valid_attributes}, valid_session
          expect(response).to redirect_to(@family)
        end
      end

      describe "with invalid params" do
        it "assigns the todo as @todo" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => invalid_attributes}, valid_session
          expect(assigns(:todo)).to eq(todo)
        end

        it "re-renders the 'edit' template" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested todo" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        expect {
          delete :destroy, {family_id: @family.id,:id => todo.to_param}, valid_session
        }.to change(Todo, :count).by(-1)
      end

      it "redirects to the family dashboard" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        delete :destroy, {family_id: @family.id,:id => todo.to_param}, valid_session
        expect(response).to redirect_to(@family)
      end
    end

  end

  context 'as a child' do
    before(:each) do
      @member = FactoryGirl.create(:member, parent: false)
      @family = @member.family
      sign_in_member(@member)
    end

    describe "GET index" do
      it "assigns all todos as @todos" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :index, {family_id: @family.id}, valid_session
        expect(assigns(:todos)).to match_array(@family.todos)
      end
    end

    describe "GET show" do
      it "assigns the requested todo as @todo" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :show, {family_id: @family.id, :id => todo.to_param}, valid_session
        expect(assigns(:todo)).to eq(todo)
      end
    end

    describe "GET new" do
      it "does not allow a new" do
        get :new, {family_id: @family.id}, valid_session
        expect(response.status).to eq(302)
        expect(flash[:error]).to be_present
      end
    end

    describe "GET edit" do
      it "does nto allow edit" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        get :edit, {family_id: @family.id, :id => todo.to_param}, valid_session
        expect(response.status).to eq(302)
        expect(flash[:error]).to be_present
      end
    end

    describe "POST create" do


        it "does not allow create" do
          post :create, {family_id: @family.id, :todo => valid_attributes}, valid_session
          expect(response.status).to eq(302)
          expect(flash[:error]).to be_present
        end



    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          {
              name: 'New Todo',
              description: 'Another description',
              required: false,
              kudos: 30,
          }
        }

        it "does not allow update" do
          todo = FactoryGirl.create(:todo, family_id: @family.id)
          put :update, {family_id: @family.id, :id => todo.to_param, :todo => new_attributes}, valid_session
          expect(response.status).to eq(302)
          expect(flash[:error]).to be_present
        end


      end


    end

    describe "DELETE destroy" do


      it "does not delete" do
        todo = FactoryGirl.create(:todo, family_id: @family.id)
        delete :destroy, {family_id: @family.id,:id => todo.to_param}, valid_session
        expect(response.status).to eq(302)
        expect(flash[:error]).to be_present
      end
    end

  end

end
