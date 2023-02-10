class LocationSerializer < ActiveModel::Serializer
    attributes :id, :name, :desc, :current_location, :visited, :exits
    has_many :items
    has_many :gamestates
end