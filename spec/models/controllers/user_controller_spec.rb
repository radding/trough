require "rails_helper"

RSpec.describe UsersController, type: :controller do
    before(:each) do 
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = User.new
        @user.email = "unique@test.com"
        @user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
        sign_in @user
        @user.reload
    end
    
    describe "only users" do
        it "hits me" do 
            get :me
            resp = JSON.parse response.body
            expect(response.code).to eq("200")
            expect(resp["id"]).to eq(@user.id)
        end

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

    describe "POST /teams/1/outings/1/users" do 
        it "joins a user to an outing" do 
            new_user = User.new
            new_user.email = "user2@test.com"
            new_user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            team = Team.create({:name => "testteam"})
            place = Place.create({ 
                name: "foo",
                google_place: "qpefij",
                rating: 1
            })
            outing = Outing.create({
                name: "test",
                departure_time: "2000-01-01 12:00:00",
                user_id: @user.id,
                team_id: team.id,
                place_id: place.id
            })

            params = {
                team_id: team.id,
                outing_id: outing.id,
                user: {
                    id: new_user.id
                }
            }
            post :join, params
            result = JSON.parse response.body
            expect(response.code).to eq("200")
            expect(result["users"].count).to eq(1)
            expect(result["users"][0]["id"]).to eq(new_user.id)
        end

        it "joins 2 users to an outing" do 
            user1 = User.new
            user1.email = "user1@test.com"
            user1.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            user2 = User.new
            user2.email = "user2@test.com"
            user2.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
            team = Team.create({:name => "testteam"})
            place = Place.create({ 
                name: "foo",
                google_place: "qpefij",
                rating: 1
            })
            outing = Outing.create({
                name: "test",
                departure_time: "2000-01-01 12:00:00",
                user_id: @user.id,
                team_id: team.id,
                place_id: place.id
            })

            params = {
                team_id: team.id,
                outing_id: outing.id,
                user: {
                    id: user1.id
                }
            }
            post :join, params
            result1 = JSON.parse response.body
            expect(response.code).to eq("200")
            expect(result1["users"].count).to eq(1)
            expect(result1["users"][0]["id"]).to eq(user1.id)

            params[:user][:id] = user2.id
            post :join, params
            result2 = JSON.parse response.body
            expect(response.code).to eq("200")
            expect(result2["users"].count).to eq(2)
            expect(result2["users"][0]["id"]).to eq(user1.id)
            expect(result2["users"][1]["id"]).to eq(user2.id)
        end
    end
end