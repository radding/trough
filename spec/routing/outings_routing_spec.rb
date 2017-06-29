require "rails_helper"

RSpec.describe OutingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/outings").to route_to("outings#index")
    end


    it "routes to #show" do
      expect(:get => "/outings/1").to route_to("outings#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/outings").to route_to("outings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/outings/1").to route_to("outings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/outings/1").to route_to("outings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/outings/1").to route_to("outings#destroy", :id => "1")
    end

  end
end
