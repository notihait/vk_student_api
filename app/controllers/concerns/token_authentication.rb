module TokenAuthentication
  extend ActiveSupport::Concern

  private

  def authenticate_token
    auth_header = request.headers["Authorization"]
    unless auth_header&.start_with?("Bearer ")
      render json: { error: "Некорректная авторизация" }, status: :unauthorized
      return false
    end

    @auth_token = auth_header.sub("Bearer ", "")
    true
  end

  def find_student_by_token
    Student.find_by(auth_token: @auth_token)
  end
end
