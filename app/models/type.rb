class Type < ApplicationRecord
    has_many :type_place
    has_many :places, through: :type_place
end
