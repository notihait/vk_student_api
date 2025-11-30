class StudentsController < ApplicationController
  include TokenAuthentication

  before_action :set_school, only: [ :create, :index ]
  before_action :set_school_class, only: [ :create, :index ]
  before_action :authenticate_token, only: [ :destroy_standalone ]
  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Related record not found" }, status: :not_found
  end

  def create_standalone
    @student = Student.new(standalone_student_params)
    if @student.save
      @student.reload
      response.headers["X-Auth-Token"] = @student.auth_token
      render :create_standalone, status: :created
    else
      render json: { errors: @student.errors.full_messages }, status: :method_not_allowed
    end
  end

  def destroy_standalone
    student = Student.find_by(id: params[:user_id])
    unless student
      return render json: { error: "Некорректный id студента" }, status: :bad_request
    end

    token_student = find_student_by_token
    unless token_student && token_student.id == student.id
      return render json: { error: "Некорректная авторизация" }, status: :unauthorized
    end

    student.destroy
    head :ok
  end

  def index
    render :index, formats: [ :json ]
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      render :create, status: :created
    else
      render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_school
    @school = School.find(params[:school_id]) if params[:school_id]
  end

  def set_school_class
    return unless params[:school_id] || params[:class_id] || params[:school_class_id]

    class_id = params[:class_id] || params[:school_class_id] || params[:id]
    @school_class = SchoolClass.find(class_id) if class_id
  end

  def student_params
    # rubocop:disable Rails/StrongParametersExpect
    params.require(:student).permit(:first_name, :last_name, :surname, :school_class_id, :school_id)
    # rubocop:enable Rails/StrongParametersExpect
  end

  def standalone_student_params
    {
      first_name: params[:first_name],
      last_name: params[:last_name],
      surname: params[:surname],
      school_class_id: params[:class_id],
      school_id: params[:school_id]
    }
  end
end
