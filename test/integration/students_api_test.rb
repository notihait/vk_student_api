require "test_helper"

class StudentsApiTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
    @school_class = school_classes(:one)
    @student = students(:one)
  end

  # POST /students - создание студента
  test "POST /students создает студента и возвращает токен" do
    student_params = {
      first_name: "Вячеслав",
      last_name: "Абдурахмангаджиевич",
      surname: "Мухобойников-Сыркин",
      class_id: @school_class.id,
      school_id: @school.id
    }

    post "/students", params: student_params, as: :json

    assert_response :created
    assert_not_nil response.headers["X-Auth-Token"]
    assert_equal 64, response.headers["X-Auth-Token"].length # SHA256 hash length

    json_response = response.parsed_body
    assert_equal "Вячеслав", json_response["data"]["first_name"]
    assert_equal "Абдурахмангаджиевич", json_response["data"]["last_name"]
    assert_equal "Мухобойников-Сыркин", json_response["data"]["surname"]
    assert_equal @school_class.id, json_response["data"]["class_id"]
    assert_equal @school.id, json_response["data"]["school_id"]
    assert_not_nil json_response["data"]["id"]
  end

  test "POST /students возвращает 405 при невалидных данных" do
    invalid_params = {
      first_name: "",
      last_name: "",
      surname: "",
      class_id: @school_class.id,
      school_id: @school.id
    }

    post "/students", params: invalid_params, as: :json

    assert_response :method_not_allowed
  end

  # DELETE /students/{user_id} - удаление студента
  test "DELETE /students/{user_id} удаляет студента с валидным токеном" do
    # Сначала создаем студента и получаем токен
    student_params = {
      first_name: "Тестовый",
      last_name: "Студент",
      surname: "Для удаления",
      class_id: @school_class.id,
      school_id: @school.id
    }

    post "/students", params: student_params, as: :json
    assert_response :created
    token = response.headers["X-Auth-Token"]
    student_id = response.parsed_body["data"]["id"]

    # Удаляем студента с токеном
    delete "/students/#{student_id}", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :success
    assert_nil Student.find_by(id: student_id)
  end

  test "DELETE /students/{user_id} возвращает 401 без токена" do
    delete "/students/#{@student.id}"

    assert_response :unauthorized
  end

  test "DELETE /students/{user_id} возвращает 401 с невалидным токеном" do
    delete "/students/#{@student.id}", headers: { "Authorization" => "Bearer invalid_token" }

    assert_response :unauthorized
  end

  test "DELETE /students/{user_id} возвращает 400 для несуществующего студента" do
    # Создаем студента и получаем токен
    student_params = {
      first_name: "Тестовый",
      last_name: "Студент",
      surname: "Для удаления",
      class_id: @school_class.id,
      school_id: @school.id
    }

    post "/students", params: student_params, as: :json
    token = response.headers["X-Auth-Token"]

    # Пытаемся удалить несуществующего студента
    delete "/students/99999", headers: { "Authorization" => "Bearer #{token}" }

    assert_response :bad_request
  end

  # GET /schools/{school_id}/classes/{class_id}/students - список студентов класса
  test "GET /schools/{school_id}/classes/{class_id}/students возвращает список студентов" do
    get "/schools/#{@school.id}/classes/#{@school_class.id}/students"

    assert_response :success
    json_response = response.parsed_body
    assert_not_nil json_response["data"]
    assert json_response["data"].is_a?(Array)

    # Проверяем структуру студента
    if json_response["data"].any?
      student = json_response["data"].first
      assert_not_nil student["id"]
      assert_not_nil student["first_name"]
      assert_not_nil student["last_name"]
      assert_not_nil student["surname"]
      assert_not_nil student["class_id"]
      assert_not_nil student["school_id"]
    end
  end

  test "GET /schools/{school_id}/classes/{class_id}/students возвращает только студентов указанного класса" do
    get "/schools/#{@school.id}/classes/#{@school_class.id}/students"

    assert_response :success
    json_response = response.parsed_body
    json_response["data"].each do |student|
      assert_equal @school_class.id, student["class_id"]
      assert_equal @school.id, student["school_id"]
    end
  end
end
