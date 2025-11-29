class StudentsController < ApplicationController
    before_action :set_school
    before_action :set_school_class
    rescue_from ActiveRecord::RecordNotFound do
      render json: { error: "Related record not found" }, status: :not_found
    end
    def create
        student = Student.new(student_params)
        if student.save
            render json: { data: student }, status: :created
        else
            render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def set_school
        @school = School.find(params[:school_id])
    end

    def set_school_class
        @school_class = SchoolClass.find(params[:school_class_id])
    end

    def student_params
        params.require(:student).permit(:first_name, :last_name, :surname, :school_class_id, :school_id)
    end
end
