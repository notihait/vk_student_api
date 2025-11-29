class SchoolsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: "School not found" }, status: :not_found
    end
  
    def index
      render json: School.all
    end
  
    def show
      render json: School.find(params[:id])
    end
  end
  