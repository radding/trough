class Place < ApplicationRecord
    has_many :type_place
    has_many :types, through: :type_place
end
