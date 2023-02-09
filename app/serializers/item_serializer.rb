class ItemSerializer < ActiveModel::Serializer
    attributes :id, :name, :desc, :location_id
    belongs_to :location
end
