require "rails_helper"

RSpec.describe Team, type: :model do
    it "tests create" do
        name = "Test"
        team = Team.create(name: name)
        expect(team.id).to be_present
    end
end