require "rails_helper"
require 'json'

RSpec.describe OutingsController, :type => :controller do
  before(:each) do 
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = User.new
    @user.email = "unique@test.com"
    @user.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
    sign_in @user

    @team = Team.create({:name => "testteam"})
    @place = Place.create({ 
      name: "foo",
      rating: 1
    })
  end

  describe "GET /teams/#/outings" do
    it "gets nothing" do 
      get :index
      expect(response.code).to eq("200")
      expect((JSON.parse response.body)["outings"]).to eq(Array.new)
    end

    it "gets a single outing" do
      outing = Outing.create({
        name: "test",
        departure_time: "2000-01-01 12-00-00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      get :index
      expect(response.code).to eq("200")
      result = (JSON.parse response.body)["outings"][0]
      expect(result["id"]).to eq(outing.id)
      expect(result["name"]).to eq(outing.name)
      #expect(result["departure_time"]).to eq(outing.departure_time)
      expect(result["place_id"]).to eq(@place.id)
      expect(result["place"]["name"]).to eq(@place.name)
    end

    it "gets multiple outings" do 
      outing1 = Outing.create({
        name: "test1",
        departure_time: "2000-01-01 12-00-00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      outing2 = Outing.create({
        name: "test2",
        departure_time: "2000-01-02 12-00-00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      get :index
      expect(response.code).to eq("200")
      result1 = (JSON.parse response.body)["outings"][0]
      expect(result1["id"]).to eq(outing1.id)
      expect(result1["name"]).to eq(outing1.name)
      #expect(result1["departure_time"]).to eq(outing1.departure_time)
      expect(result1["place_id"]).to eq(@place.id)
      expect(result1["place"]["name"]).to eq(@place.name)
      
      result2 = (JSON.parse response.body)["outings"][1]
      expect(result2["id"]).to eq(outing2.id)
      expect(result2["name"]).to eq(outing2.name)
      #expect(result2["departure_time"]).to eq(outing2.departure_time)
      expect(result2["place_id"]).to eq(@place.id)
      expect(result2["place"]["name"]).to eq(@place.name)

      expect(result1["place_id"]).to eq(result2["place_id"])
    end
  end

  describe "POST /outings" do 
    it "creates new outing" do 
      params = {
        team_id: @team.id,
        outing: {
          name: "test",
          user_id: @user.id,
          place: {
            name: "foo"
          },
          departure_time: "2000-01-01 12-00-00" 
        }
      }
      post :create, params
      expect(response.code).to eq("201")
    end
  end
end