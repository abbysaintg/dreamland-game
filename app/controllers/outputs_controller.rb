class OutputsController < ApplicationController

    # INDEX 
    def index 
        render json: Output.all
    end

    # CREATE 
    def create
        output = Output.create!(output_params)
        render json: output, status: :created
    end

    private 

    def output_params
        params.permit(:text)
    end
end
