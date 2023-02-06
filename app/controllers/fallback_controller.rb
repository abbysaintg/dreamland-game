class FallbackController < ActionController::Base
    # render the HTML file for our React application
    def index
        render file: "public/index.html"
    end
end
