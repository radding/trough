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
    @team.users << @user
    @place = Place.create({ 
      name: "foo",
      google_place: "qpefij",
      rating: 1
    })
  end

  describe "GET /teams/1/outings" do
    it "gets nothing" do 
      get :index, team_id: @team.id
      expect(response.code).to eq("200")
      expect((JSON.parse response.body)).to eq(Array.new)
    end

    it "gets a single outing" do
      outing = Outing.create({
        name: "test",
        departure_time: "2000-01-01 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      get :index, team_id: @team.id
      expect(response.code).to eq("200")
      result = (JSON.parse response.body)[0]
      expect(result["id"]).to eq(outing.id)
      expect(result["name"]).to eq(outing.name)
      expect(Time.zone.parse(result["departure_time"])).to eq(outing.departure_time)
      expect(result["place"]["name"]).to eq(@place.name)
    end

    it "gets multiple outings" do 
      outing1 = Outing.create({
        name: "test1",
        departure_time: "2000-01-01 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      outing2 = Outing.create({
        name: "test2",
        departure_time: "2000-01-02 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      get :index, team_id: @team.id
      expect(response.code).to eq("200")
      result1 = (JSON.parse response.body)[0]
      expect(result1["id"]).to eq(outing1.id)
      expect(result1["name"]).to eq(outing1.name)
      expect(Time.zone.parse(result1["departure_time"])).to eq(outing1.departure_time)
      expect(result1["place"]["name"]).to eq(@place.name)
      
      result2 = (JSON.parse response.body)[1]
      expect(result2["id"]).to eq(outing2.id)
      expect(result2["name"]).to eq(outing2.name)
      expect(Time.zone.parse(result2["departure_time"])).to eq(outing2.departure_time)
      expect(result2["place"]["name"]).to eq(@place.name)

    end

    it "gets only new Outings" do 
      user2 = User.new
      user2.email = "unique2@test.com"
      user2.update({:password => "testtesttest", :password_confirmation => "testtesttest"})
      team1 = Team.create({:name => "testteam11"})
      team1.users << user2
      @team.users << user2
      outing1 = Outing.create({
        name: "test1",
        departure_time: "2000-01-01 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      outing4 = Outing.create({
        name: "test4",
        departure_time: "2000-01-01 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      outing2 = Outing.create({
        name: "test2",
        departure_time: "2000-01-02 12:00:00",
        user_id: user2.id,
        team_id: @team.id,
        place_id: @place.id
      })

      outing3 = Outing.create({
        name: "test3",
        departure_time: "2000-01-02 12:00:00",
        user_id: user2.id,
        team_id: @team.id,
        place_id: @place.id
      })

       outing5 = Outing.create({
        name: "test3",
        departure_time: "2000-01-02 12:00:00",
        user_id: user2.id,
        team_id: team1.id,
        place_id: @place.id
      })

      outing = Outing.create({
        name: "test3",
        departure_time: "2000-01-02 12:00:00",
        user_id: user2.id,
        team_id: team1.id,
        place_id: @place.id
      })
      get :index, team_id: @team.id, exclude_me: true
      result = JSON.parse response.body
      expect(result.count).to eq(2)

      outing3.users << @user      
      get :index, team_id: @team.id, exclude_me: true
      result = JSON.parse response.body
      expect(result.count).to eq(1)      
    end
    
  end

  describe "POST /teams/1/outings" do 
    it "creates new outing" do 
      outing = Outing.create({
        name: "test",
        departure_time: "2000-01-01 12:00:00",
        user_id: @user.id,
        team_id: @team.id,
        place_id: @place.id
      })
      params = {
        team_id: @team.id,
        outing: {
          name: "test",
          creator: @user.attributes,
          place: {
            google_place: "",
            name: "foo"
          },
          departure_time: "2000-01-01 12:00:00" 
        }
      }
      post :create, params
      result = JSON.parse response.body
      expect(response.code).to eq("201")
      expect(result["creator"]["id"]).to eq(@user.id)
      expect(result["name"]).to eq(params[:outing][:name])
      expect(Time.zone.parse(result["departure_time"])).to eq(Time.zone.parse(params[:outing][:departure_time]))
      expect(result["place"]["name"]).to eq(@place.name)
    end
  end

  describe "PUT /teams/1/outings" do 
	  it "creates new outing" do 
      post_params = {
        team_id: @team.id,
        outing: {
          name: "test",
          creator: @user.attributes,
          place: {
            google_place: "",
            name: "foo"
          },
          departure_time: "2000-01-01 12:00:00" 
        }
      }
	    post :create, post_params
      result = JSON.parse response.body

      put_params = {
        team_id: result["team_id"],
        id: result["id"],
        outing: {
          name: "new name",
          creator: @user,
          place: @place,
          departure_time: result["departure_time"]
        }
      }
      put :update, put_params
	    expect(response.code).to eq("200")
      result = JSON.parse response.body
      expect(result["name"]).to eq("new name")
	  end
	end
end