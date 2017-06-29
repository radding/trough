require "rails_helper"
require 'json'

RSpec.describe OutingsController, :type => :controller do
    before(:each) do 
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = User.new
        user.email = "unique@test.com"
        user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
        sign_in user

        @team = Team.create({:name => "testteam"})
    end

    describe "GET /outings" do
        it "gets nothing" do 
            get :index
            expect(response.code).to eq("200")
            expect(response.body).to eq("[]")
        end

        it "gets outing by team id" do
            outing = Outing.create({
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
            expect(result["id"]).to eq(outing.id)
            expect(result["name"]).to eq(outing.name)
            expect(result["when"].to eq(outing.when))
            expect(result["place"]["id"].to eq(outing.place.id))
            expect(result["place"]["name"].to eq(outing.place.name))
        end

        it "gets multiple outings" do 
            team = Team.create(name: "test")
            get :show, :id => team.id
            expect(response.code).to eq("200")
        end
    end

    describe "POST /outings" do 
        it "creates new outing" do 
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