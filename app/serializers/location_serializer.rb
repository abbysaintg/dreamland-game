class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :current_room
  has_many :items
end
