require "rails_helper"
require 'json'

RSpec.describe TeamsController, :type => :controller do

    describe "GET /teams" do
        it "gets nothing" do 
            get :index
            expect(response.code).to eq("200")
            expect(response.body).to eq("[]")
        end

        it "gets something" do
            teams = Team.create(name: "test")
            get :index
            expect(response.code).to eq("200")
            result = (JSON.parse response.body)[0]
            expect(result["id"]).to eq(teams.id)
            expect(result["name"]).to eq(teams.name)
        end

        it "tests showup" do 
            team = Team.create(name: "test")
            get :show, :id => team.id
            expect(response.code).to eq("200")
        end

        it "retrieve by search" do
            names = ["Tests", "test", "tester", "tele", "stuff", "creations"]
            names.map do |name|
                team = Team.create(name: name)
            end
            get :index, s: "te"
            expect(response.code).to eq("200")
            result = JSON.parse response.body
            expect(result.count).to eq(4)

            get :index, s: "test"
            expect(response.code).to eq("200")
            result = JSON.parse response.body
            expect(result.count).to eq(3)
        end
    end

    describe "POST /teams" do 
        it "creates new team" do 
            post :create, {"team" => {"name" => "test"}}
            expect(response.code).to eq("201")

            post :create, {"team" => {"name" => "test"}}
            expect(response.code).to eq("409")
        end
    end

    describe "PUT /teams" do 
        it "creates new team" do 
            post :create, {"team" => {"name" => "test"}}
            result = JSON.parse response.body
            result[:name] = "test2"
            put :update, params: {id: result["id"], "team" => result}
            expect(response.code).to eq("200")
        end
    end
    
end