class OutingSerializer < ActiveModel::Serializer
  attributes :id, :name, :departure_time, :user_id, :team_id, :place_id
  has_one :place
end
