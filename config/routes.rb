Rails.application.routes.draw do
  # OpenAPI спецификация требует отдельные эндпоинты для студентов
  post "/students", to: "students#create_standalone"
  delete "/students/:user_id", to: "students#destroy_standalone"

  # Явные маршруты для соответствия OpenAPI спецификации (должны быть перед resources)
  get "/schools/:school_id/classes/:class_id/students", to: "students#index"
  get "/schools/:school_id/classes", to: "school_classes#index"

  resources :schools do
    # Используем 'classes' вместо 'school_classes' для соответствия OpenAPI
    resources :school_classes, path: "classes" do
      resources :students, except: [:index]
    end
  end
end
