class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :in_inventory
  has_one :location
end
