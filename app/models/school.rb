class School < ApplicationRecord
  has_many :school_classes, dependent: :destroy
  has_many :students, through: :school_classes

  validates :name, presence: true
end
