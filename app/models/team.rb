class Team < ApplicationRecord
    validates :name, uniqueness: true

    before_validation do
        self.name = self.name.downcase
    end

    def self.with(characters)
        where("name ILIKE ?", "%#{characters}%")
    end
end
