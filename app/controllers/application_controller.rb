class ApplicationController < ActionController::API
    include ActionController::Cookies

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    before_action :authorize

    private

    def authorize
        @current_user = User.find_by(id: session[:user_id])
    end

    def record_not_found(exception)
        render json: { error: "#{exception.model} not found" }, status: :not_found
    end

    def record_invalid(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
