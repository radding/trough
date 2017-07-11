class OutingSerializer < ActiveModel::Serializer
  attributes :id, :name, :team_id, :departure_time
  has_one :place
  has_one :creator, :class_name => "user"
  has_many :users, through: :user_outings
end
