Rails API приложение для управления студентами, классами и школами. Полная реализация API согласно OpenAPI спецификации.

vk_int/
├── app/
│   ├── controllers/          # Контроллеры API
│   │   ├── concerns/         # TokenAuthentication concern
│   │   ├── students_controller.rb
│   │   ├── school_classes_controller.rb
│   │   └── schools_controller.rb
│   ├── models/               # Модели данных
│   │   ├── student.rb
│   │   ├── school_class.rb
│   │   └── school.rb
│   └── views/                # Jbuilder шаблоны
│       ├── students/
│       └── school_classes/
├── config/
│   ├── routes.rb             # Маршруты API
│   └── database.yml           # Конфигурация БД
├── db/
│   └── migrate/              # Миграции базы данных
├── test/                     # Тесты
│   ├── integration/          # Интеграционные тесты
│   └── fixtures/             # Тестовые данные
├── docker-compose.yml        # Конфигурация Docker Compose
├── Dockerfile                # Образ приложения
└── openapi.yaml              # Спецификация API


Проект создан в рамках тестового задания.

