class UsersController < ApplicationController
    skip_before_action :authorize, only: :create

    def index 
        render json: User.all, status: :ok
    end

    def show 
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
