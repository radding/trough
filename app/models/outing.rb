class Outing < ApplicationRecord
    belongs_to :place
    belongs_to :creator, class_name: "User", foreign_key: :user_id
    has_many :user_outing
    has_many :users, through: :user_outing
end
