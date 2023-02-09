class GamestateSerializer < ActiveModel::Serializer
    attributes :id, :output, :input, :location_id
    belongs_to :location
end
