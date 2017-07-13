class Outing < ApplicationRecord
    belongs_to :place
    belongs_to :team
    belongs_to :creator, class_name: "User", foreign_key: :user_id
    has_many :user_outing
    has_many :users, through: :user_outing

    scope :excludes, ->(user) {
        joins('LEFT JOIN user_outings ON user_outings.outing_id = outings.id')
        .where('user_outings.user_id != ? OR user_outings.user_id is null AND outings.user_id != ?', user.id, user.id)
    }
end
