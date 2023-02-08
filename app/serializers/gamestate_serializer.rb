class GamestateSerializer < ActiveModel::Serializer
  attributes :id, :output, :input, :room
end
