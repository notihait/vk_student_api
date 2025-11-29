Rails.application.routes.draw do
  resources :schools do
    resources :school_classes do
      resources :students
    end
  end  
end
