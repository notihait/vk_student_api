class SchoolClassesController < ApplicationController
    before_action :set_school
    rescue_from ActiveRecord::RecordNotFound do
       render json: { error: "School not found" }, status: :not_found
    end
    def index
        render json: { data: @school.school_classes }
    end



    private

    def set_school
        @school = School.find(params[:school_id])
    end
end
