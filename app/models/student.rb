require "digest"

class Student < ApplicationRecord
  belongs_to :school_class
  belongs_to :school

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :surname, presence: true
  validates :auth_token, uniqueness: true, allow_nil: true

  after_create :generate_auth_token

  # Для соответствия OpenAPI спецификации
  def as_json(options = {})
    super(options).merge(
      "class_id" => school_class_id,
      "school_id" => school_id
    ).except("school_class_id")
  end

  private

  def generate_auth_token
    return if auth_token.present?

    secret_salt = Rails.application.secret_key_base
    new_token = Digest::SHA256.hexdigest("#{id}#{secret_salt}")
    # rubocop:disable Rails/SkipsModelValidations
    # update_column используется намеренно для обновления токена без валидаций после создания
    update_column(:auth_token, new_token)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
