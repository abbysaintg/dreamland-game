class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :location
end
