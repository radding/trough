require "rails_helper"

RSpec.describe Team, type: :model do
    it "tests create" do
        name = "TEST"
        team = Team.create(name: name)
        other_team = Team.new(name: "test")
        expect(other_team).not_to be_valid
        expect(team.id).to be_present
        expect(team.name).to eq(team.name)
    end

    it "tests searching" do 
        names = ["Tests", "test", "tester", "tele", "stuff", "creations"]
        names.map do |name|
            team = Team.create(name: name)
        end
        expect(Team.with("te").count).to eq(4)
        expect(Team.with("tes").count).to eq(3)
        expect(Team.with("s").count).to eq(5)
    end
    
end