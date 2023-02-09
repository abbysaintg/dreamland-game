class Location < ApplicationRecord
    has_many :items
    has_many :gamestates
end
