class Team < ApplicationRecord
    validates :name, uniqueness: true

    has_many :teams_users
    has_many :users, through: :teams_users
    has_many :outings

    before_validation do
        self.name = self.name.downcase
    end

    def self.with(characters)
        where("name ILIKE ?", "%#{characters}%")
    end
end
