class UsersController < ApplicationController
    skip_before_action :authorize, only: :create

    def index 
        render json: User.all, status: :ok
    end

    def show 
        # user = @current_user
        # if user
        #     render json: @current_user
        # else 
        #     render json: { error: "Wrong username or password." }, status: :not_found
        # end
        render json: @current_user
        # user = User.find(params[:id])
        # render json: user
    end

    def create 
        user = User.create!(user_params)
        session[:user_id] = user.id
        if user.save
            render json: user, status: :created
        else
            render :new
        end
        
    end

    def destroy 
        user = User.find(params[:id])
        user.destroy 
        head :no_content
    end

    private 

    def user_params
        params.permit(:username, :password)
    end

end
