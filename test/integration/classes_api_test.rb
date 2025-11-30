require "test_helper"

class ClassesApiTest < ActionDispatch::IntegrationTest
  setup do
    @school = schools(:one)
    @school_class = school_classes(:one)
  end

  # GET /schools/{school_id}/classes - список классов школы
  test "GET /schools/{school_id}/classes возвращает список классов" do
    get "/schools/#{@school.id}/classes"

    assert_response :success
    json_response = response.parsed_body
    assert_not_nil json_response["data"]
    assert json_response["data"].is_a?(Array)

    # Проверяем структуру класса
    if json_response["data"].any?
      school_class = json_response["data"].first
      assert_not_nil school_class["id"]
      assert_not_nil school_class["number"]
      assert_not_nil school_class["letter"]
      assert_not_nil school_class["students_count"]
    end
  end

  test "GET /schools/{school_id}/classes возвращает только классы указанной школы" do
    get "/schools/#{@school.id}/classes"

    assert_response :success
    json_response = response.parsed_body
    # Загружаем все классы одним запросом для избежания N+1
    class_ids = json_response["data"].map { |sc| sc["id"] }
    actual_classes = SchoolClass.where(id: class_ids).index_by(&:id)

    json_response["data"].each do |school_class|
      # Проверяем, что класс принадлежит указанной школе
      actual_class = actual_classes[school_class["id"]]
      assert_equal @school.id, actual_class.school_id
    end
  end

  test "GET /schools/{school_id}/classes возвращает правильное количество студентов" do
    get "/schools/#{@school.id}/classes"

    assert_response :success
    json_response = response.parsed_body
    # Загружаем все классы с подсчетом студентов одним запросом для избежания N+1
    class_ids = json_response["data"].map { |sc| sc["id"] }
    actual_classes = SchoolClass.where(id: class_ids)
                                 .left_joins(:students)
                                 .group("school_classes.id")
                                 .count("students.id")

    json_response["data"].each do |school_class|
      assert_equal actual_classes[school_class["id"]], school_class["students_count"]
    end
  end
end
