class LocationSerializer < ActiveModel::Serializer
    attributes :id, :name, :desc, :current_location, :visited
    has_many :items
    has_many :gamestates
end
