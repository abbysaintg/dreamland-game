class Gamestate < ApplicationRecord
    belongs_to :location
    belongs_to :user
end
