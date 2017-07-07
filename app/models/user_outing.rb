class UserOuting < ApplicationRecord
    belongs_to :outing
    belongs_to :user
end
