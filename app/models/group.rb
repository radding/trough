class Group < ApplicationRecord
    belongs_to :place
    belongs_to :creator, class_name: "User", foreign_key: :user_id
    has_many :group_user
    has_many :users, through: :group_user
end
