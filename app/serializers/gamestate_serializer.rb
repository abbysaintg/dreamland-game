class GamestateSerializer < ActiveModel::Serializer
    attributes :id, :output, :input, :location_id, :user_id
    belongs_to :location
    belongs_to :user
end
