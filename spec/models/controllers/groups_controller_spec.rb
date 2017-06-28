require "rails_helper"
require 'json'

RSpec.describe GroupsController, :type => :controller do
    before(:each) do 
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = User.new
        user.email = "unique@test.com"
        user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
        sign_in user

        @team = Team.create({:name => "testteam"})
    end

    describe "GET /groups" do
        it "gets nothing" do 
            get :index
            expect(response.code).to eq("200")
            expect(response.body).to eq("[]")
        end

        it "gets group by team id" do
            group = Group.create({
                name: "test",
                user_id: @user.id,
                team_id: @team.id,
                outing: "2000-01-01 12:00",
                place: {
                    name: "foo"
                }
            })
            get :index
            expect(response.code).to eq("200")
            result = (JSON.parse response.body)[0]
            expect(result["id"]).to eq(group.id)
            expect(result["name"]).to eq(group.name)
            expect(result["when"].to eq(group.when))
            expect(result["place"]["id"].to eq(group.place.id))
            expect(result["place"]["name"].to eq(group.place.name))
        end

        it "gets multiple groups" do 
            team = Team.create(name: "test")
            get :show, :id => team.id
            expect(response.code).to eq("200")
        end
    end

    describe "POST /groups" do 
        it "creates new group" do 
            post :create, {
                name: "test",
                user_id: @user.id,
                team_id: @team.id,
                when: "2000-01-01 12:00",
                place: {
                    name: "foo"
                }
            }
            expect(response.code).to eq("201")
        end
    end
end