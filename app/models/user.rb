class User < ApplicationRecord
    after_create :create_default_gamestates
    has_secure_password
    has_many :gamestates, dependent: :destroy

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true

    private

    def create_default_gamestates
        Gamestate.create(location_id: 4, user_id: self.id, output: "Welcome to Dreamland.")
        Gamestate.create(location_id: 4, user_id: self.id, output: "If you need help, try typing \"help\" and then hit enter.")
        Gamestate.create(location_id: 4, user_id: self.id, output: "You are half asleep in bed. Moonlight streams through the window, casting the room in shadows. The clock on your nightstand reads 2:34AM. A ghostly figure stands at the end of your bed, a translucent hand extended to you.")
    end
end
