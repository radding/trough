require "rails_helper"

RSpec.describe UsersController, type: :controller do
    before(:each) do 
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = User.new
        user.email = "unique@test.com"
        user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
        sign_in user
    end
    
    describe "only users" do
        it "updates user" do 
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            get :show, :id => user.id

            resp = JSON.parse response.body
            resp["name"] = "tester testington"

            put :update, :id => user.id, :user => resp
            expect(response.code).to eq("200")
            user.reload
            expect(user.name).to eq("tester testington")
        end
        
        it "gets users" do
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            user = User.new
            user.email = "test2@test.com" 
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})                       
            get :index
            expect(response.code).to eq("200")
            result = JSON.parse response.body
            expect(result.count).to eq(3)
        end
        
        it "gets specific users" do
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            user = User.new
            user.email = "test2@test.com" 
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            get :show, :id => user.id
            expect(response.code).to eq("200")
            result = JSON.parse response.body

            expect(result["id"]).to eq(user.id)
            expect(result["email"]).to eq(user.email)
        end

        it "deletes users" do 
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            user = User.new
            user.email = "test2@test.com" 
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            get :show, :id => user.id
            expect(response.code).to eq("200")
            result = JSON.parse response.body

            expect(result["id"]).to eq(user.id)
            expect(result["email"]).to eq(user.email)

            delete :destroy, :id => user.id
            expect(response.code).to eq("204")
            
            expect(User.all.count).to eq(2)

            user = User.new
            user.email = "test3@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            team = Team.create({name: "test"})
            team.users << user

            delete :destroy, :id => user.id
            expect(response.code).to eq("204")
            
            expect(User.all.count).to eq(2)
        end
    end

    describe "with teams" do
        it "adds to team with put" do 
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            team = Team.create({name: "test"})
            expect(team.users.count).to eq(0)
            put :update, :team_id => team.id, :id => user.id

            team.reload
            expect(team.users.count).to eq(1)

            user.reload
            expect(user.teams.count).to eq(1)
        end

        it "removes from team" do
            user = User.new
            user.email = "test@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            team = Team.create({name: "test"})
            team.users << user

            user = User.new
            user.email = "teswt@test.com"
            user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})

            team.users << user


            team.reload
            expect(team.users.count).to eq(2)

            delete :destroy, :team_id => team.id, :id => user.id
            team.reload
            expect(team.users.count).to eq(1)

        end
    end
end